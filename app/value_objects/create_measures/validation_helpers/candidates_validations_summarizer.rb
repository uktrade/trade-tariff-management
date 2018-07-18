module CreateMeasures
  module ValidationHelpers
    class CandidatesValidationsSummarizer

      attr_accessor :candidates

      def initialize(candidates)
        @candidates = candidates
      end

      def errors
        res = {}

        candidates.map do |code, errors_list|
          errors_list.map do |k, v|
            v.flatten.map do |error_message|
              new_error_with_code = [ error_message, [code] ]

              if res.has_key?(k)
                if res[k].map { |el| el[0] }.include?(error_message)
                  item = res[k].detect { |el| el[0] == error_message }
                  item[1] << code
                else
                  res[k] << new_error_with_code
                end

              else
                if res[k].is_a?(Array)
                  res[k] << new_error_with_code
                else
                  res[k] = [ new_error_with_code ]
                end
              end
            end
          end
        end

        res
      end
    end
  end
end
