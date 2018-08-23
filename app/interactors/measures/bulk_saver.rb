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
                  :workbasket

    def initialize(current_admin, workbasket, collection_ops=[])
      @errors_collection = {}
      @current_admin = current_admin
      @workbasket = workbasket

      @collection_ops = collection_ops.map do |item_ops|
        ActiveSupport::HashWithIndifferentAccess.new(item_ops)
      end
    end

    def valid?
      validate_collection!
      no_errors?
    end

    def persist!
      Rails.logger.info ""
      Rails.logger.info " PERSIST! "
      Rails.logger.info ""

      Rails.cache.write("#{workbasket.id}_sequence_number", nil)

      workbasket.items.map do |item|
        item.persist_measure!
      end

      workbasket.status = "awaiting_cross_check"
      workbasket.operation_date = Date.today + 1.day
      workbasket.save
    end

    def success_response
      {
        number_of_updated_measures: collection_ops.count,
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
          item = workbasket.get_item_by_id(
            measure_params[:measure_sid].to_s
          )
          item.new_data = measure_params.to_json

          errors = Workbaskets::Workbasket.validate_measure!(measure_params)

          if errors.present?
            errored_columns = Measures::BulkErroredColumnsDetector.new(errors).errored_columns
            @errors_collection[
              measure_params[:measure_sid].to_s
            ] = errored_columns

            item.validation_errors = errored_columns.to_json
          end

          item.save
        end
      end

      def no_errors?
        errors_collection.blank?
      end
  end
end
