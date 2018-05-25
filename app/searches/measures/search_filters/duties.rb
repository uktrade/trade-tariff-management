#
# Form parameters:
#
# {
#    operator: 'include',
#    value: [
#       { '99' => '10' },
#       { '01' => '15' }
#    ] (eg: array of hashes, where key (eg: '99') is duty_expression_id and value is 'user input')
# }
#
# Operator possible options:
#
# - are
# - include
#
# Exxample:
#
# ::Measures::SearchFilters::Duties.new(
#   "include", [ {'99' => '10'}, { '01' => '15' } ]
# ).sql_rules
#

module Measures
  module SearchFilters
    class Duties

      attr_accessor :operator,
                    :duties_list

      def initialize(operator, duties_list)
        @operator = operator
        @duties_list = duties_list
      end

      def sql_rules
        sql = "#{initial_filter_sql} AND (#{duty_expression_collection_sql_rules})"
        sql += " AND #{count_comparison_sql_rule}" if operator == "are"

        sql
      end

      private

        def initial_filter_sql
          "(searchable_data -> 'duty_expressions')::text <> '[]'::text"
        end

        def duty_expression_collection_sql_rules
          duties_list.map do |duty_ops|
            q_rule = duty_expression_id_sql_rule(duty_ops)

            amount = duty_expression_amount(duty_ops)
            if amount.present?
              q_rule += "AND #{duty_expression_amount_sql_rule(amount)}"
            end

            "(#{q_rule})"
          end.join(" AND ")
        end

        def count_comparison_sql_rule
          <<-eos
            searchable_data #>> '{"duty_expressions_count"}' = '#{duties_list.count}'
          eos
        end

        def duty_expression_id_sql_rule(duty_ops)
          d_id = duty_expression_id(duty_ops)

          <<-eos
            searchable_data @> '{"duty_expressions": [{"duty_expression_id": "#{d_id}"}]}'"
          eos
        end

        def duty_expression_amount_sql_rule(amount)
          <<-eos
            searchable_data @> '{"duty_expressions": [{"duty_amount": "#{amount}"}]}'"
          eos
        end

        def duty_expression_id(duty_ops)
          duty_ops.keys[0]
                  .strip
        end

        def duty_expression_amount(duty_ops)
          duty_ops.values[0]
                  .strip
        end
    end
  end
end
