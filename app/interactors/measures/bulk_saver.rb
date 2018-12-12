module Measures
  class BulkSaver
    include ::CustomLogger

    VALIDATING_OPS = %w[
      validity_start_date
      validity_end_date
      goods_nomenclature
      regulation
      measure_type
      additional_code
      geographical_area
      footnotes
      measure_components
      measure_conditions
      excluded_geographical_areas
    ].freeze

    attr_accessor :current_admin,
                  :collection_ops,
                  :errors_collection,
                  :workbasket,
                  :workbasket_settings

    def initialize(current_admin, workbasket, collection_ops = [])
      @errors_collection = {}
      @current_admin = current_admin
      @workbasket = workbasket
      @workbasket_settings = workbasket.settings

      @collection_ops = collection_ops.map do |item_ops|
        ActiveSupport::HashWithIndifferentAccess.new(item_ops)
      end
    end

    def valid?
      validate_collection!
      no_errors?
    end

    def persist!
      workbasket.clean_up_related_cache!

      workbasket.items.map(&:persist!)

      workbasket.move_status_to!(current_admin, :awaiting_cross_check)
    end

    def success_response
      {
        number_of_updated_measures: collection_ops.count,
        collection_row_ids: collection_row_ids,
        success: :ok
      }
    end

    def error_response
      {
        measures_with_errors: errors_collection,
      }
    end

  private

    def validate_collection!
      collection_ops.each_with_index do |measure_params, _index|
        item = workbasket_settings.get_item_by_id(
          measure_params[:measure_sid].to_s
        )
        item.new_data = measure_params.to_json
        item.row_id = measure_params[:row_id].to_s

        if item.deleted?
          item.validation_errors = [].to_json

        else
          errors = item.validate!(measure_params)

          if errors.present?
            errored_columns = Measures::BulkErroredColumnsDetector.new(errors).errored_columns
            @errors_collection[
              measure_params[:row_id].to_s
            ] = errored_columns

            item.validation_errors = errors.to_json
          end
        end

        item.save
      end
    end

    def collection_row_ids
      collection_ops.map do |i|
        i['row_id'].to_s
      end
    end

    def no_errors?
      errors_collection.blank?
    end
  end
end
