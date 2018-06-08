module Measures
  class MeasuresController < ApplicationController

    include ::SearchCacheHelpers

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

    expose(:search_ops) do
      ops = params[:search]

      if ops.present?
        ops.send("permitted=", true)
        ops = ops.to_h
      else
        ops = {}
      end

      setup_advanced_filters(ops)
    end

    expose(:measures_search) do
      if search_mode?
        ::Measures::Search.new(
          Rails.cache.read(search_code).merge(
            page: params[:page] || 1
          )
        )
      else
        []
      end
    end

    expose(:search_results) do
      measures_search.results
    end

    expose(:json_collection) do
      search_results.map(&:to_table_json)
                    .to_json
    end

    expose(:form) do
      MeasureForm.new(Measure.new)
    end

    def index
      respond_to do |format|
        format.json { render json: json_collection }
        format.html
      end
    end

    def search
      redirect_to measures_url(search_code: search_code)
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
