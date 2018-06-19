module Measures
  class BulkSaver

    include ::CustomLogger

    attr_accessor :current_admin,
                  :collection_ops,
                  :candidates

    def initialize(current_admin, collection_ops=[])
      @candidates = []

      @current_admin = current_admin
      @collection_ops = collection_ops.map do |item_ops|
        ActiveSupport::HashWithIndifferentAccess.new(item_ops)
      end

      log_it("collection_ops: #{@collection_ops.inspect}")
    end


    def valid?
      validate_collection!
      no_errors?
    end

    def persist!
      # TODO
    end

    private

      def validate_collection!
        collection_ops.each_with_index do |measure_params, index|
          errors = validate_measure!(measure_params)

          collection_ops[index] = if errors.present?
            measure_params.merge(
              errors: errors
            )
          else
            measure_params
          end
        end
      end

      def any_errors?
        collection_ops.any? do |item|
          item[:errors].present?
        end
      end

      def no_errors?
        !any_errors?
      end

      def validate_measure!(measure_params={})
        errors = {}

        measure = Measure.new(measure_params)
        measure.measure_sid = Measure.max(:measure_sid).to_i + 1

        base_validator = MeasureValidator.new.validate(measure)

        if measure.conformance_errors.present?
          measure.conformance_errors.map do |error_code, error_details_list|
            errors[get_error_area(base_validator, error_code)] = error_details_list
          end
        end

        errors
      end

      def get_error_area(base_validator, error_code)
        base_validator.detect do |v|
          v.identifiers == error_code
        end.validation_options[:of]
      end
  end
end
