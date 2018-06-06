module Measures
  class BulksController < ApplicationController

    skip_around_action :configure_time_machine

    expose(:bulk_saver) do
      collection_ops = params[:measures]
      collection_ops.send("permitted=", true)
      collection_ops = collection_ops.to_h

      ::Measures::BulkSaver.new(current_user, collection_ops)
    end

    expose(:bulk_collection) do
      ::Measure.where(measure_sid: params[:measure_sids])
    end

    def edit
      respond_to do |format|
        format.json { render json: bulk_collection.map(&:to_table_json) }
        format.html
      end
    end

    def info
      render json: bulk_collection.map(&:to_json).to_json
    end

    def validate
      if bulk_saver.valid?
        success_response
      else
        errors_response
      end
    end

    def create
      if bulk_saver.valid?
        bulk_saver.persist!

        success_response
      else
        errors_response
      end
    end

    private

      def success_response
        render json: bulk_saver.collection_overview_summary,
               status: :ok
      end

      def errors_response
        render json: bulk_saver.collection_with_errors,
               status: :unprocessable_entity
      end
  end
end
