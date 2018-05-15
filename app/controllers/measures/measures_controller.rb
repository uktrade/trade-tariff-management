module Measures
  class MeasuresController < ApplicationController

    expose(:measure_saver) do
      measure_ops = params[:measure]
      measure_ops.send("permitted=", true)
      measure_ops = measure_ops.to_h

      ::MeasureSaver.new(current_user, measure_ops)
    end

    expose(:measure) do
      measure_saver.measure
    end

    expose(:measures) do
      scope = Measure
      scope = scope.by_regulation_id(params[:regulation_id]) if params[:regulation_id].present?
      scope = scope.q_search(params[:code]) if params[:code].present?

      scope.page(params[:page] || 1)
           .per(25)
    end

    expose(:form) do
      MeasureForm.new(Measure.new)
    end

    def create
      if measure_saver.valid?
        measure_saver.persist!

        render json: {
          measure_sid: measure.measure_sid,
          goods_nomenclature_item_id: measure.goods_nomenclature_item_id
        }, status: :ok
      else
        render json: { errors: measure_saver.errors },
               status: :unprocessable_entity
      end
    end
  end
end
