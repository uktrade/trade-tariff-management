module WorkbasketValueObjects
  module Shared
    class ConformanceErrorsParser
      attr_accessor :record,
                    :base_validator,
                    :errors

      def initialize(record, validator, errors)
        @record = record
        @base_validator = validator.new
        @errors = errors

        base_validation!

        self
      end

    private

      def base_validation!
        @base_validator = base_validator.validate(record)

        if record.conformance_errors.present?
          record.conformance_errors.map do |error_code, error_details_list|
            @errors[get_error_area(error_code)] = error_details_list.map do |error_message|
              code = error_code
              code = code.join(', ') if error_code.is_a?(Array)

              message = error_message
              message = message.tr("\n", "") if message.include?("\n")

              "#{code}: #{message}"
            end.uniq
          end
        end
      end

      def get_error_area(error_code)
        base_validator.detect do |v|
          v.identifiers == error_code
        end.validation_options[:of]
      end
    end
  end
end
