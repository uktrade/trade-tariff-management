class MeasureParamsNormalizer

  ALIASES = {
    start_date: :validity_start_date,
    end_date: :validity_end_date
  }

  attr_accessor :normalized_params

  def initialize(measure_params)
    @normalized_params = {}

    measure_params.map do |k, v|
      if ALIASES.keys.include?(k.to_sym)
        @normalized_params[ALIASES[k.to_sym]] = v
      else
        @normalized_params[k] = v
      end
    end

    @normalized_params
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
      @errors[:validity_start_date] = "can't be blank!"
      return false
    else
      @measure = Measure.new(measure_params)

      validate!
      errors.blank?
    end
  end

  private

    def validate!
      measure_base_validation!
    end

    def measure_base_validation!
      base_validator.validate(measure)

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
end
