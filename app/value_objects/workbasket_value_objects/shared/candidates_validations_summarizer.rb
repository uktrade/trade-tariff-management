module WorkbasketValueObjects
  module Shared
    class CandidatesValidationsSummarizer

      attr_accessor :step,
                    :candidates,
                    :errors

      def initialize(step, candidates)
        @step = step
        @candidates = candidates

        @errors = {}
      end

      def summarize!
        candidates.map do |code, error_groups|
          error_groups.map do |group_key, errors_list|
            if group_key == :measure
              parse_errors_list(group_key, code, errors_list)

            else
              errors_list.map do |position, errors_collection|
                parse_errors_list(group_key, code, errors_collection)
              end
            end
          end
        end
      end

      private

        def parse_errors_list(group_key, code, errors_list)
          errors[group_key] = {} unless errors.has_key?(group_key)

          errors_list.map do |k, v|
            v.flatten.map do |error_message|
              new_error_with_code = [ error_message, [code] ]

              if errors[group_key].has_key?(k)
                if errors[group_key][k].map { |el| el[0] }.include?(error_message)
                  item = errors[group_key][k].detect { |el| el[0] == error_message }
                  item[1] << code unless item[1].include?(code)
                else
                  errors[group_key][k] << new_error_with_code
                end

              else
                if errors[group_key][k].is_a?(Array)
                  errors[group_key][k] << new_error_with_code
                else
                  errors[group_key][k] = [ new_error_with_code ]
                end
              end
            end
          end
        end
    end
  end
end
