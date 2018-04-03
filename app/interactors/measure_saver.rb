class MeasureParamsNormalizer

  ALIASES = {
    start_date: :validity_start_date,
    end_date: :validity_end_date,
    quota_ordernumber: :ordernumber,
    goods_nomenclature_code: :method_goods_nomenclature_item_values,
    additional_code: :method_additional_code_values,
    regulation_id: :method_regulation_values,
    geographical_area_id: :method_geographical_area_values
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

  attr_accessor :measure_params,
                :measure,
                :errors

  def initialize(measure_params={})
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
end
