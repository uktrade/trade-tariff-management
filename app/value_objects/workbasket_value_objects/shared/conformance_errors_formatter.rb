module WorkbasketValueObjects
  module Shared
    class ConformanceErrorsFormatter

      attr_accessor :record,
                    :errors

      def initialize(record)
        @record = record
        @errors = {}

        format!

        self
      end

      def format!
        record.conformance_errors.map do |error_code, error_details_list|
          @errors[get_error_area(error_code)] = error_details_list.map do |error_message|
            code = error_code
            code = code.join(', ') if error_code.is_a?(Array)

            message = error_message
            message = message.tr("\n","") if message.include?("\n")

            "#{code}: #{message}"
          end.uniq
        end
      end

      private

        def get_error_area(error_code)
          base_validator.detect do |v|
            v.identifiers == error_code
          end.validation_options[:of]
        end
    end
  end
end
