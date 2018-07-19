module CreateMeasures
  module ValidationHelpers
    class CandidatesValidationsSummarizer

      attr_accessor :candidates,
                    :prepared_errors

      def initialize(candidates)
        @candidates = candidates
        @prepared_errors = {}
      end

      def parse_errors_list(code, errors_list)
        errors_list.map do |k, v|
          v.flatten.map do |error_message|
            new_error_with_code = [ error_message, [code] ]

            if prepared_errors.has_key?(k)
              if prepared_errors[k].map { |el| el[0] }.include?(error_message)
                item = prepared_errors[k].detect { |el| el[0] == error_message }
                item[1] << code unless item[1].include?(code)
              else
                prepared_errors[k] << new_error_with_code
              end

            else
              if prepared_errors[k].is_a?(Array)
                prepared_errors[k] << new_error_with_code
              else
                prepared_errors[k] = [ new_error_with_code ]
              end
            end
          end
        end
      end

      def errors
        candidates.map do |code, error_groups|
          error_groups.map do |group_key, errors_list|
            if group_key == :measure
              parse_errors_list(code, errors_list)
            else
              errors_list.map do |position, errors_collection|
                parse_errors_list(code, errors_collection)
              end
            end
          end
        end

        prepared_errors
      end
    end
  end
end
