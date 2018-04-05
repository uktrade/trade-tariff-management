class MeasureParamsNormalizer

  ALIASES = {
    start_date: :validity_start_date,
    end_date: :validity_end_date,
    quota_ordernumber: :ordernumber,
    goods_nomenclature_code: :method_goods_nomenclature_item_values,
    additional_code: :method_additional_code_values,
    regulation_id: :method_regulation_values,
    geographical_area_id: :method_geographical_area_values,
  }

  WHITELIST_PARAMS = %w(
    start_date
    end_date
    goods_nomenclature_code
    quota_ordernumber
    measure_type_id
    regulation_id
    geographical_area_id
  )

  attr_accessor :normalized_params

  def initialize(measure_params)
    @normalized_params = {}

    whitelist = measure_params.select do |k, v|
      WHITELIST_PARAMS.include?(k) && v.present?
    end

    whitelist.map do |k, v|
      if ALIASES.keys.include?(k.to_sym)
        if ALIASES[k.to_sym].to_s.starts_with?("method_")
          @normalized_params.merge!(
            send(ALIASES[k.to_sym], measure_params[k])
          )
        else
          @normalized_params[ALIASES[k.to_sym]] = v
        end
      else
        @normalized_params[k] = v
      end
    end

    @normalized_params
  end

  private

    def method_additional_code_values(additional_code_id)
      additional_code = AdditionalCode.actual
                                      .where(additional_code: additional_code_id).first

      {
        additional_code_type_id: additional_code.additional_code_type_id,
        additional_code_sid: additional_code.additional_code_sid,
        additional_code_id: additional_code_id
      }
    end

    def method_regulation_values(base_regulation_id)
      regulation = BaseRegulation.actual
                                 .not_replaced_and_partially_replaced
                                 .where(base_regulation_id: base_regulation_id).first

      ops = {
        measure_generating_regulation_role: regulation.base_regulation_role,
        measure_generating_regulation_id: base_regulation_id
      }

      if normalized_params[:validity_end_date].present?
        ops[:justification_regulation_id] = base_regulation_id
        ops[:justification_regulation_role] = regulation.base_regulation_role
      end

      ops
    end

    def method_geographical_area_values(geographical_area_id)
      geographical_area = GeographicalArea.actual
                                          .where(geographical_area_id: geographical_area_id).first

      {
        geographical_area_id: geographical_area_id,
        geographical_area_sid: geographical_area.geographical_area_sid
      }
    end

    def method_goods_nomenclature_item_values(goods_nomenclature_item_id)
      commodity = Commodity.actual
                           .declarable
                           .where(goods_nomenclature_item_id: goods_nomenclature_item_id).first

      {
        goods_nomenclature_item_id: goods_nomenclature_item_id,
        goods_nomenclature_sid: commodity.goods_nomenclature_sid
      }
    end
end

class MeasureSaver

  attr_accessor :original_params,
                :measure_params,
                :measure,
                :errors

  def initialize(measure_params={})
    @original_params = ActiveSupport::HashWithIndifferentAccess.new(measure_params)
    @measure_params = ::MeasureParamsNormalizer.new(measure_params).normalized_params

    p ""
    p "-" * 100
    p ""
    p " normalized_params: #{@measure_params.inspect}"
    p ""
    p "-" * 100
    p ""

    @errors = {}
  end

  def valid?
    if measure_params[:validity_start_date].blank?
      @errors[:validity_start_date] = "Start date can't be blank!"
      return false
    else
      @measure = Measure.new(measure_params)
      #
      # We need to assign `measure_sid` Measure before assign Geographical Area or Measure Type
      # Otherwise, we are getting
      # Sequel::Error `does not have a primary key`
      #
      # This is because MeasureValidator class is tend to work with already persisted
      # database record.
      #
      generate_measure_sid

      validate!
      errors.blank?
    end
  end

  def persist!
    generate_measure_sid
    measure.manual_add = true
    measure.operation = "I"
    measure.operation_date = Date.current

    attempts = 5

    begin
      measure.save
    rescue Exception => e
      attempts -= 1
      generate_measure_sid

      if attempts > 0
        retry
      else
        raise "Can't save measure: #{e.message.inspect}"
      end
    end

    post_saving_updates!

    p ""
    p "[SAVED MEASURE] sid: #{measure.measure_sid} | #{measure.inspect}"
    p ""
  end

  private

    def validate!
      measure_base_validation!
    end

    def measure_base_validation!
      @base_validator = base_validator.validate(measure)

      if measure.conformance_errors.present?
        measure.conformance_errors.map do |error_code, error_details_list|
          @errors[get_error_area(error_code)] = error_details_list
        end
      end
    end

    def base_validator
      @base_validator ||= MeasureValidator.new
    end

    def get_error_area(error_code)
      base_validator.detect do |v|
        v.identifiers == error_code
      end.validation_options[:of]
    end

    def generate_measure_sid
      measure.measure_sid = Measure.max(:measure_sid) + 1
    end

    def post_saving_updates!
      add_quota_definitions!
      add_excluded_geographical_areas!
    end

    def add_quota_definitions!
      if measure.ordernumber.present?
        quota_def_ops = original_params["quota_periods"]
        mode = quota_def_ops.keys.first
        target_ops = quota_def_ops[mode]

        p "-" * 100
        p ""
        p " mode: #{mode}, target_ops: #{target_ops.inspect}"
        p ""
        p "-" * 100

        if target_ops.present?
          case mode
          when "annual", "bi_annual", "quarterly", "monthly"
            add_quota_definition!(mode, target_ops) if target_ops[:start_date].present?
          when "custom"
            add_custom_quota_definition!(target_ops)
          end
        end
      end
    end

    def add_quota_definition!(mode, data)
      data.keys.select do |k|
        k.starts_with?("amount")
      end.map do |k|
        p "-" * 100
        p ""
        p " add_quota_definition! - k: #{k}"
        p ""
        p " ops: #{quota_ops(mode, data, k).inspect}"
        p ""
        p "-" * 100

        quota_definition = QuotaDefinition.new(quota_ops(mode, data, k))
        set_oplog_attrs_and_save!(quota_definition)
      end
    end

    def add_custom_quota_definition!(data)
      data.map do |k, v|

        p ""
        p "+" * 100
        p ""
        p " [CUSTOM] k: #{k}, data: #{custom_quota_ops(v)}"
        p ""
        p "+" * 100
        p ""

        quota_definition = QuotaDefinition.new(custom_quota_ops(v))
        set_oplog_attrs_and_save!(quota_definition)
      end
    end

    def quota_ops(mode, data, k)
      {
        volume: data[k],
        measurement_unit_code: data[:measurement_unit_code],
        measurement_unit_qualifier_code: data[:measurement_unit_qualifier_code],
      }.merge(quota_definition_main_ops)
       .merge(quota_definition_start_and_date_ops(mode, data, k))
    end

    def custom_quota_ops(data)
      {
        volume: data["amount1"],
        validity_start_date: data[:start_date].to_date,
        validity_end_date: data[:end_date].try(:to_date),
        measurement_unit_code: data[:measurement_unit_code],
        measurement_unit_qualifier_code: data[:measurement_unit_qualifier_code],
      }.merge(quota_definition_main_ops)
    end

    def quota_definition_main_ops
      quota_order_number = measure.order_number

      {
        quota_order_number_id: quota_order_number.quota_order_number_id,
        quota_order_number_sid: quota_order_number.quota_order_number_sid,
        critical_threshold: original_params[:quota_criticality_threshold],
        critical_state: original_params[:quota_status] == "critical" ? "Y" : "N",
        description: original_params[:quota_description],
      }
    end

    def quota_definition_start_and_date_ops(mode, data, k)
      ops = {}
      start_date = data[:start_date].to_date
      amount_number = k.gsub("amount", "").to_i

      case mode
      when "annual"
        ops[:validity_start_date] = start_date
        ops[:validity_end_date] = start_date + 1.year
      when "bi_annual"
        step_range = amount_number * 6
        ops[:validity_start_date] = start_date + (step_range - 6).months
        ops[:validity_end_date] = start_date + step_range.months
      when "monthly"
        ops[:validity_start_date] = start_date + (amount_number - 1).months
        ops[:validity_end_date] = start_date + amount_number.months
      when "quarterly"
        step_range = amount_number * 3
        ops[:validity_start_date] = start_date + (step_range - 3).months
        ops[:validity_end_date] = start_date + step_range.months
      end

      ops
    end

    def add_excluded_geographical_areas!
      excluded_areas = original_params[:excluded_geographical_areas]

      if excluded_areas.present?
        excluded_areas.map do |area_code|
          add_excluded_geographical_area!(area_code)
        end
      end
    end

    def add_excluded_geographical_area!(area_code)
      area = GeographicalArea.actual
                             .where(geographical_area_id: area_code)
                             .first

      excluded_area = MeasureExcludedGeographicalArea.new(
        excluded_geographical_area: area_code
      )

      excluded_area.geographical_area_sid = area.geographical_area_sid
      excluded_area.measure_sid = measure.measure_sid
      set_oplog_attrs_and_save!(excluded_area)
    end

    def set_oplog_attrs_and_save!(record)
      record.operation = "I"
      record.operation_date = Date.current
      record.manual_add = true

      record.save
    end
end
