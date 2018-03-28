class MeasureSaver

  attr_accessor :measure_params,
                :measure,
                :measure_sid,
                :errors

  def initialize(measure_params=nil)
    @measure_params = measure_params
    @errors = []
  end

  def persist!
    # TODO
  end

  def valid?
    validate

    errors.blank?
  end

  private

    def validate
      # TODO
    end
end
