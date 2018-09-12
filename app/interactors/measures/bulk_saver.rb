module Measures
  class BulkSaver

    include ::CustomLogger

    VALIDATING_OPS = [
      "validity_start_date",
      "validity_end_date",
      "goods_nomenclature",
      "regulation",
      "measure_type",
      "additional_code",
      "geographical_area",
      "footnotes",
      "measure_components",
      "measure_conditions",
      "excluded_geographical_areas"
    ]

    attr_accessor :current_admin,
                  :collection_ops,
                  :errors_collection,
                  :workbasket,
                  :workbasket_settings

    def initialize(current_admin, workbasket, collection_ops=[])
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

      workbasket.items.map do |item|
        item.persist!
      end

      workbasket.status = "awaiting_cross_check"
      workbasket.save
    end

    def success_response
      {
        number_of_updated_measures: collection_ops.count,
        collection_sids: collection_sids,
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
        collection_ops.each_with_index do |measure_params, index|
          item = workbasket_settings.get_item_by_id(
            measure_params[:measure_sid].to_s
          )
          item.new_data = measure_params.to_json

          if item.deleted?
            item.validation_errors = [].to_json

          else
            errors = item.validate_measure!(measure_params)

            if errors.present?
              errored_columns = Measures::BulkErroredColumnsDetector.new(errors).errored_columns
              @errors_collection[
                measure_params[:measure_sid].to_s
              ] = errored_columns

              item.validation_errors = errored_columns.to_json
            end
          end

          item.save
        end
      end

      def collection_sids
        collection_ops.map do |i|
          i['measure_sid'].to_s
        end
      end

      def no_errors?
        errors_collection.blank?
      end
  end
end
