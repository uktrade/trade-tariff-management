module FormApiHelpers
  module RegulationSearch
    extend ActiveSupport::Concern

    included do
      dataset_module do
        def q_search(primary_key, keyword)
          q_rule = "#{keyword}%"

          scope = if %w(base_regulation_id modification_regulation_id).include?(primary_key.to_s)
            not_replaced_and_partially_replaced.actual_or_starts_in_future
          else
            not_replaced_and_partially_replaced
          end

          scope.where(
            "#{primary_key} ilike ? OR information_text ilike ?",
            q_rule, q_rule
          ).limit(100)
        end

        def not_replaced_and_partially_replaced
          where("replacement_indicator = 0 OR replacement_indicator = 2")
        end
      end
    end

    def regulation_id
      public_send(primary_key[0])
    end

    def json_mapping(details_with_code=false)
      res = {
        regulation_id: regulation_id,
        description: details(details_with_code),
        formatted_id: formatted_id
      }

      case self.class.name
      when "CompleteAbrogationRegulation"
        res[:complete_abrogation_regulation_id] = res[:regulation_id]
      when "ExplicitAbrogationRegulation"
        res[:explicit_abrogation_regulation_id] = res[:regulation_id]
      end

      res[:role] = public_send(primary_key[1])
      res
    end

    def details(details_with_code)
      res = if details_with_code.present?
        "#{regulation_id}: #{information_text}"
      else
        information_text
      end
      res += " (#{date_to_uk(reg_date)})" if reg_date.present?
      res = "#{res} to #{date_to_uk(effective_end_date)})" if try(:effective_end_date).present?

      res
    end

    def reg_date
      case self.class.name
      when "CompleteAbrogationRegulation"
        published_date
      when "ExplicitAbrogationRegulation"
        published_date || abrogation_date
      else
        validity_start_date
      end
    end

    def date_to_uk(date)
      date.try(:to_formatted_s, :uk)
    end
  end
end
