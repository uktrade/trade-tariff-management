#
# Form parameters:
#
# {
#    operator: 'include',
#    value: [
#       'A',
#       'B'
#    ] (eg: array of selected measure condition codes')
# }
#
# Operator possible options:
#
# - are
# - include
# - are_not_specified
# - are_not_unspecified
#
# Example:
#
# ::Measures::SearchFilters::Conditions.new(
#   "include", [ 'A', 'B' ]
# ).sql_rules
#

module Measures
  module SearchFilters
    class Conditions < ::Shared::SearchFilters::CollectionFilterBase
      OPERATORS_WITH_REQUIRED_PARAMS = %w(
        are
        include
      ).freeze

      attr_accessor :operator,
                    :conditions_list

      def initialize(operator, conditions_list)
        @operator = operator

        @conditions_list = if conditions_list.present?
                             filtered_collection_params(conditions_list)
                           else
                             []
        end
      end

      def sql_rules
        return nil if required_options_are_blank?

        if %w(are include).include?(operator)

          sql = "#{initial_filter_sql} AND (#{collection_sql_rules})"
          sql += " AND #{count_comparison_sql_rule}" if operator == "are"

          [sql, *collection_compare_values].flatten
        else
          case operator
          when "are_not_specified"

            are_not_specified_sql_rule
          when "are_not_unspecified"

            are_not_unspecified_sql_rule
          end
        end
      end

    private

      def required_options_are_blank?
        OPERATORS_WITH_REQUIRED_PARAMS.include?(operator) &&
          conditions_list.size.zero?
      end

      def initial_filter_sql
        <<-eos
          searchable_data #>> '{"measure_conditions"}' IS NOT NULL
        eos
      end

      def collection_sql_rules
        conditions_list.map do
          <<-eos
            (searchable_data #>> '{"measure_conditions"}')::text ilike ?
          eos
        end.join(" AND ")
      end

      def collection_compare_values
        conditions_list.map do |code|
          "%_#{code}_%"
        end
      end

      def count_comparison_sql_rule
        <<-eos
            searchable_data #>> '{"measure_conditions_count"}' = '#{conditions_list.count}'
        eos
      end

      def are_not_specified_sql_rule
        <<-eos
          searchable_data #>> '{"measure_conditions"}' IS NULL
        eos
      end

      def are_not_unspecified_sql_rule
        <<-eos
          searchable_data #>> '{"measure_conditions"}' IS NOT NULL
        eos
      end
    end
  end
end
