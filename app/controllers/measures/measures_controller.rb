module Measures
  class MeasuresController < ApplicationController

    skip_around_action :configure_time_machine, only: [:index]

    expose(:measure_saver) do
      measure_ops = params[:measure]
      measure_ops.send("permitted=", true)
      measure_ops = measure_ops.to_h

      ::MeasureSaver.new(current_user, measure_ops)
    end

    expose(:measure) do
      measure_saver.measure
    end

    expose(:search_ops) {
      ops = params[:search] || {}
      ops = setup_advanced_filters(ops)

      ops.merge(
        page: params[:page] || 1
      )
    }

    expose(:measures_search_form) do
      ::MeasuresSearchForm.new(search_ops)
    end

    expose(:measures_search) do
      ::MeasuresSearch.new(search_ops)
    end

    expose(:search_results) do
      measures_search.results
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

    def bulk_edit
      @measures = Measure.where(measure_sid: params[:measure_sids])

      respond_to do |format|
        format.json { render json: @measures.map(&:to_table_json) }
        format.html
      end
    end

    private

      def setup_advanced_filters(ops)
        if params[:regulation_id].present?
          ops[:regulation] = {
            operator: 'is',
            value: params[:regulation_id]
          }
        end

        if params[:code].present?
          ops[:commodity_code] = {
            operator: 'is',
            value: params[:code]
          }
        end

        ops
      end
  end
end
