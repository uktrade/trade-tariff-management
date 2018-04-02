module Measures
  class MeasuresController < ApplicationController

    expose(:measure_saver) do
      measure_ops = params[:measure]
      measure_ops.send("permitted=", true)
      measure_ops = measure_ops.to_h

      p ""
      p "-" * 100
      p ""
      p " CONTROLLER PARAMS: #{measure_ops.inspect}"
      p ""
      p "-" * 100
      p ""

      ::MeasureSaver.new(measure_ops)
    end

    def index
      @measures = Measure.page(params[:page] || 1).per(25)
    end

    def new
      @form = MeasureForm.new(Measure.new)
    end

    def create
      if measure_saver.valid?
        measure_saver.persist!

        render json: { measure_sid: measure_saver.measure_sid },
               status: :ok
      else
        render json: { errors: measure_saver.errors },
               status: :unprocessable_entity
      end
    end
  end
end
