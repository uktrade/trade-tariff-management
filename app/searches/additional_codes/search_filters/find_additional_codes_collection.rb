module AdditionalCodes
  module SearchFilters
    module FindAdditionalCodesCollection
      include ::Shared::SearchFilters::FindCollection

      def order_by(field, direction)
        if (field)
          if field == "type_id"
            field = "additional_code_type_id"
          end

          order_symbol = "all_additional_codes__#{field}".to_sym
          direction = (direction == 'desc' ? 'desc' : 'asc')

          order(Sequel.send(direction, order_symbol),
                Sequel.asc(:all_additional_codes__additional_code_type_id),
                Sequel.asc(:all_additional_codes__additional_code)
          )
        else
          order(Sequel.asc(:all_additional_codes__additional_code_type_id),
                Sequel.asc(:all_additional_codes__additional_code)
          )
        end
      end

      def operator_search_by_additional_code_type(operator, additional_code_type_id = nil)
        is_or_is_not_search_query("additional_code_type_id", operator, additional_code_type_id)
      end

      def operator_search_by_code(operator, additional_code)
        operator_search_where_clause("AdditionalCode", operator, additional_code)
      end

      def operator_search_by_workbasket_name(operator, workbasket_name)
        q_rules = ::AdditionalCodes::SearchFilters::WorkbasketName.new(
          operator, workbasket_name
        ).sql_rules
        q_rules.present? ? self.join(:workbaskets, id: :all_additional_codes__workbasket_id).where(q_rules) : self
      end

      def operator_search_by_description(operator, description)
        operator_search_where_clause("Description", operator, description)
      end

    private

      def operator_search_where_clause(klass_name, operator, value = nil)
        q_rules = "::AdditionalCodes::SearchFilters::#{klass_name}".constantize.new(
          operator, value
        ).sql_rules

        q_rules.present? ? where(q_rules) : self
      end
    end
  end
end
