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

      {
        measure_generating_regulation_role: regulation.base_regulation_role,
        measure_generating_regulation_id: base_regulation_id
      }
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
    measure.operation = "C"
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
        periods_ops = original_params["quota_periods"]

        if periods_ops.present?
          if periods_ops["annual"].present?
            add_quota_definition!(:annual, periods_ops["annual"])
          elsif periods_ops["bi_annual"].present?
            add_quota_definition!(:bi_annual, periods_ops["bi_annual"])
          elsif periods_ops["quarterly"].present?
            add_quota_definition!(:quarterly, periods_ops["quarterly"])
          elsif periods_ops["monthly"].present?
            add_quota_definition!(:monthly, periods_ops["monthly"])
          elsif periods_ops["custom"].present?
            add_custom_quota_definition!(:custom, periods_ops["custom"])
          end
        end
      end
    end

    def add_quota_definition!(mode, data)
      data.keys.select do |k, v|
        k.starts_with?("amount")
      end.map do |k, volume|
        quota_definition = QuotaDefinition.new(
          {
            volume: volume,
            measurement_unit_code: data[:measurement_unit_code],
            measurement_unit_qualifier_code: data[:measurement_unit_qualifier_code],
          }.merge(quota_definition_main_ops)
           .merge(quota_definition_start_and_date_ops(mode, data))
        )
      end
    end

    def quota_definition_main_ops
      quota_order_number = measure.order_number

      {
        quota_order_number_id: quota_order_number.quota_order_number_id,
        quota_order_number_sid: quota_order_number.quota_order_number_sid,
        critical_threshold: original_params[:quota_criticality_threshold],
        critical_state: original_params[:quota_status] == "critical" ? "Y" : "N",
        description: original_params[:description],
      }
    end

    def quota_definition_start_and_date_ops(mode, data)
      ops = { validity_start_date: data[:start_date].to_date }
      ops[:validity_end_date] = data[:end_date].to_date if data[:end_date].present?

      ops
    end

    def add_custom_quota_definition!(data)
      # TODO
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
      excluded_area.operation_date = Date.current
      excluded_area.manual_add = true

      excluded_area.save
    end
end
