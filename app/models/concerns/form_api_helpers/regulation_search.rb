module FormApiHelpers
  module RegulationSearch
    extend ActiveSupport::Concern

    included do
      dataset_module do
        def q_search(primary_key, keyword)
          q_rule = "#{keyword}%"

          actual.not_replaced_and_partially_replaced
                .where(
            "#{primary_key} ilike ? OR information_text ilike ?",
            q_rule, q_rule
          )
        end

        def not_replaced_and_partially_replaced
          where("replacement_indicator = 0 OR replacement_indicator = 2")
        end
      end
    end

    def json_mapping
      res = {
        regulation_id: primary_key[0],
        description: details
      }

      res[:role] = base_regulation_role if res[:regulation_id] == :base_regulation_id

      res
    end

    def details
      res = "#{primary_key[0]}: #{information_text} (#{date_to_uk(validity_start_date)})"
      res = "#{res} to #{date_to_uk(effective_end_date)})" if effective_end_date.present?

      res
    end

    def date_to_uk(date)
      date.to_formatted_s(:uk)
    end
  end
end
