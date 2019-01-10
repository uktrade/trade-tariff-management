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
# Example:
#
# ::Measures::SearchFilters::Duties.new(
#   "include", [ {'99' => '10'}, { '01' => '15' } ]
# ).sql_rules
#

module Measures
  module SearchFilters
    class Duties < ::Shared::SearchFilters::CollectionFilterBase
      attr_accessor :operator,
                    :duties_list

      def initialize(operator, duties_list)
        @operator = operator

        @duties_list = if duties_list.present?
                         filtered_hash_collection_params(duties_list)
                       else
                         []
        end
      end

      def sql_rules
        return nil if duties_list.size.zero?

        sql = "#{initial_filter_sql} AND (#{collection_sql_rules})"
        sql += " AND #{count_comparison_sql_rule}" if operator == "are"

        sql
      end

    private

      def initial_filter_sql
        "(searchable_data -> 'duty_expressions')::text <> '[]'::text"
      end

      def collection_sql_rules
        duties_list.map do |duty_ops|
          q_rule = item_id_sql_rule(duty_ops)

          amount = item_amount(duty_ops)
          q_rule += "AND #{item_amount_sql_rule(amount)}" if amount.present?

          "(#{q_rule})"
        end.join(" AND ")
      end

      def count_comparison_sql_rule
        <<-eos
            searchable_data #>> '{"duty_expressions_count"}' = '#{duties_list.count}'
        eos
      end

      def item_id_sql_rule(ops)
        d_id = item_id(ops)[0..1]

        <<-eos
            searchable_data @> '{"duty_expressions": [{"duty_expression_id": "#{d_id}"}]}'
        eos
      end

      def item_amount_sql_rule(amount)
        <<-eos
            searchable_data @> '{"duty_expressions": [{"duty_amount": "#{amount}"}]}'
        eos
      end

      def item_id(duty_ops)
        duty_ops.keys[0]
                .strip
      end

      def item_amount(duty_ops)
        val = duty_ops.values[0]
                      .strip

        val.present? ? val.to_f.to_s : ""
      end
    end
  end
end
