#
# Form parameters:
#
# {
#   operator: 'include',
#   value: [
#     '495',
#     '546'
#   ] (eg: array of geographical area IDs)
# }
#
# Operator possible options:
#
# - include
# - do_not_include
# - are_not_specified
# - are_not_unspecified
#
# Example:
#
# ::Measures::SearchFilters::OriginExclusions.new(
#   "include", [ '495', '546' ]
# ).sql_rules
#

module Measures
  module SearchFilters
    class OriginExclusions

      OPERATORS_WITH_REQUIRED_PARAMS = %w(
        include
        do_not_include
      )

      attr_accessor :operator,
                    :exclusions_list

      def initialize(operator, exclusions_list)
        @operator = operator
        @exclusions_list = exclusions_list.uniq!
      end

      def sql_rules
        return nil if required_options_are_blank?

        case operator
        when "include", "do_not_include"
          main_operator = operator == "include" ? "AND" : "OR"
          sql = "#{initial_sql_rule} #{main_operator} (#{collection_sql_rules})"

          [sql, *collection_compare_values].flatten
        when "are_not_specified"

          are_not_specified_sql_rule
        when "are_not_unspecified"

          are_not_unspecified_sql_rule
        end
      end

      private

        def required_options_are_blank?
          OPERATORS_WITH_REQUIRED_PARAMS.include?(operator) &&
          exclusions_list.size.zero?
        end

        def initial_sql_rule
          case operator
          when "include"
            are_not_unspecified_sql_rule
          when "do_not_include"
            are_not_specified_sql_rule
          end
        end

        def collection_sql_rules
          prefix = operator == "do_not_include" ? "NOT" : ""

          exclusions_list.map do
            <<-eos
              (searchable_data #>> '{"excluded_geographical_areas"}')::text #{prefix} ilike ?
            eos
          end.join(" AND ")
        end

        def collection_compare_values
          filtered_collection_params(exclusions_list).map do |origin_id|
            "%_#{origin_id}_%"
          end
        end

        def are_not_specified_sql_rule
          <<-eos
            searchable_data #>> '{"excluded_geographical_areas"}' IS NULL
          eos
        end

        def are_not_unspecified_sql_rule
          <<-eos
            searchable_data #>> '{"excluded_geographical_areas"}' IS NOT NULL
          eos
        end

        def filtered_collection_params(list)
          p ""
          p "-" * 100
          p ""
          p " list: #{list.inspect}"
          p ""
          p "-" * 100
          p ""

          res = list.map(&:strip)
              .select do |item|
            item.present?
          end

          p ""
          p "-" * 100
          p ""
          p " res: #{res.inspect}"
          p ""
          p "-" * 100
          p ""

          res
        end
    end
  end
end
