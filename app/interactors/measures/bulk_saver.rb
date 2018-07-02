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
                  :workbasket,
                  :errors_collection

    def initialize(current_admin, workbasket, collection_ops=[])
      @errors_collection = []

      @current_admin = current_admin
      @workbasket = workbasket
      @collection_ops = collection_ops.map do |item_ops|
        ActiveSupport::HashWithIndifferentAccess.new(item_ops)
      end

      log_it("collection_ops: #{@collection_ops.inspect}")
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
          Rails.logger.info ""
          Rails.logger.info "-" * 100
          Rails.logger.info ""
          Rails.logger.info "  [#{index} | #{measure_params[:measure_sid]}]"
          Rails.logger.info ""
          Rails.logger.info "-" * 100
          Rails.logger.info ""

          errors = validate_measure!(measure_params)

          Rails.logger.info ""
          Rails.logger.info "-" * 100
          Rails.logger.info ""
          Rails.logger.info "  [#{index} | #{measure_params[:measure_sid]}] #{errors.inspect}"
          Rails.logger.info ""
          Rails.logger.info "-" * 100
          Rails.logger.info ""

          if errors.present?
            @collection_ops[index] = measure_params.merge(
              errors: errors
            )
            @errors_collection[measure_params[:measure_sid]] = ::Measures::BulkErroredColumnsDetector.new(errors)
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

        Rails.logger.info ""
        Rails.logger.info "-" * 100
        Rails.logger.info ""
        Rails.logger.info " Ops prepared, trying to validate #{measure.inspect}"
        Rails.logger.info ""
        Rails.logger.info "-" * 100
        Rails.logger.info ""

        base_validator = MeasureValidator.new.validate(measure)

        if measure.conformance_errors.present?
          measure.conformance_errors.map do |error_code, error_details_list|
            errors[get_error_area(base_validator, error_code)] = error_details_list
          end
        end

        errors
      end

      def no_errors?
        errors_collection.blank?
      end

      def get_error_area(base_validator, error_code)
        base_validator.detect do |v|
          v.identifiers == error_code
        end.validation_options[:of]
      end
  end
end
