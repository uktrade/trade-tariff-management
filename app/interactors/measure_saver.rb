class MeasureParamsNormalizer

  ALIASES = {
    start_date: :validity_start_date,
    end_date: :validity_end_date,
    goods_nomenclature_code: :goods_nomenclature_item_id,
    quota_ordernumber: :ordernumber,
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
      p "+" * 100
      p ""
      p " #{k} : #{v}"
      p ""

      if ALIASES.keys.include?(k.to_sym)
        p ""
        p " v.to_s.starts_with?('method_'): #{v.to_s.starts_with?('method_')}"
        p ""

        if ALIASES[k.to_sym].to_s.starts_with?("method_")

          p " ALIASES[k.to_sym]: #{ALIASES[k.to_sym]}"
          p ""
          p " measure_params[k]: #{measure_params[k]}"
          p ""
          p " send(ALIASES[k.to_sym], measure_params[k]): #{send(ALIASES[k.to_sym], measure_params[k])}"
          p ""
          p "+" * 100
          p ""

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
end

class MeasureSaver

  attr_accessor :measure_params,
                :measure,
                :measure_sid,
                :errors

  def initialize(measure_params={})
    p ""
    p "-" * 100
    p ""
    p " measure_params: #{measure_params.inspect}"
    p ""
    p "-" * 100
    p ""

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

  def persist!
    # TODO
  end

  def valid?
    if measure_params[:validity_start_date].blank?
      @errors[:validity_start_date] = "Start date can't be blank!"
      return false
    else
      p ""
      p " --------------------0---measure_params: #{measure_params.inspect}---------------------------"
      p ""

      @measure = Measure.new(measure_params)
      #
      # We need to assign `measure_sid` Measure before assign Geographical Area or Measure Type
      # Otherwise, we are getting
      # Sequel::Error `does not have a primary key`
      #
      # This is because MeasureValidator class is tend to work with already persisted
      # database record.
      #
      measure.measure_sid = Measure.max(:measure_sid) + 1

      p ""
      p " --------------------1------------------------------"
      p ""

      validate!

      p ""
      p " ---------------------2-----------------------------"
      p ""
      errors.blank?
    end
  end

  private

    def validate!
      measure_base_validation!
    end

    def measure_base_validation!
      @base_validator = base_validator.validate(measure)

      if measure.conformance_errors.present?
        p ""
        p " measure.conformance_errors: #{measure.conformance_errors.inspect}"
        p ""

        measure.conformance_errors.map do |error_code, error_details_list|

          p ""
          p " error_code: #{error_code}"
          p ""
          p " error_details_list: #{error_details_list.inspect}"
          p ""

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
end
