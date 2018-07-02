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
      @errors_collection = []
      @current_admin = current_admin
      @workbasket = workbasket

      @collection_ops = collection_ops.map do |item_ops|
        ActiveSupport::HashWithIndifferentAccess.new(item_ops)
      end
    end

    def save_new_data_json_values!
      collection_ops.map do |item_ops|
        item = workbasket.get_item_by_id(
          item_ops[:measure_sid].to_s
        )

        item.new_data = item_ops.to_json
        item.save
      end
    end

    def valid?
      validate_collection!
      no_errors?
    end

    def success_response
      {
        number_of_updated_measures: collection_ops.count,
        measures_with_errors: errors_collection.map { |r| r.measure_sid },
        success: :ok
      }
    end

    private

      def validate_collection!
        collection_ops.each_with_index do |measure_params, index|
          errors = validate_measure!(measure_params)

          if errors.present?
            @errors_collection[
              measure_params[:measure_sid]
            ] = Measures::BulkErroredColumnsDetector.new(errors).errored_columns
          end
        end
      end

      def validate_measure!(measure_params={})
        errors = {}

        measure = Measure.new(
          ::Measures::BulkParamsConverter.new(
            measure_params
          ).converted_ops
        )

        measure.measure_sid = Measure.max(:measure_sid).to_i + 1

        ::Measures::ValidationHelper.new(
          measure, {}
        ).errors
      end

      def no_errors?
        errors_collection.blank?
      end
  end
end
