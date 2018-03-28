class MeasuresController < ApplicationController

  expose(:measure_saver) do
    ::MeasureSaver.new(params[:measure])
  end

  def index
    @measures = Measure.paginate(params[:page] || 1, 25)
  end

  def new
    @form = MeasureForm.new(Measure.new)
  end

  def create
    if measure_form.valid?
      measure_form.persist!

      render json: { measure_sid: measure_form.measure_sid },
             status: :ok
    else
      render json: { errors: measure_form.errors },
             status: :unprocessable_entity
    end
  end
end
