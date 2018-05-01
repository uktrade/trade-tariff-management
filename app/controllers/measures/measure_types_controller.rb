module Measures
  class MeasureTypesController < ::BaseController

    expose(:filter_ops) do
      ops = {}

      if params[:measure_type_series_id].present?
        ops[:measure_type_series_id] = params[:measure_type_series_id]
      end
      ops[:q] = params[:q] if params[:q].present?

      ops
    end

    def collection
      MeasureType.q_search(filter_ops)
    end
  end
end
