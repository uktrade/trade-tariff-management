#
# Form parameters:
#
# {
#   operator: 'include',
#   value: [
#     { 'WR' => '101' },
#     { 'AR' => '234' },
#   ] (eg: array of hashes, where key (eg: 'WR') is footnote_type_id
#          and value is 'user input aka footnote id')
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
# ::Measures::SearchFilters::Footnotes.new(
#   "include", [ { 'WR' => '101' }, { 'AR' => '234' } ]
# ).sql_rules
#

module Measures
  module SearchFilters
    class Footnotes < ::Shared::SearchFilters::CollectionFilterBase
      OPERATORS_WITH_REQUIRED_PARAMS = %w(
        are
        include
      ).freeze

      attr_accessor :operator,
                    :footnotes_list

      def initialize(operator, footnotes_list)
        @operator = operator

        @footnotes_list = if footnotes_list.present?
                            filtered_hash_collection_params(footnotes_list)
                          else
                            []
        end
      end

      def sql_rules
        return nil if required_options_are_blank?

        if %w(are include).include?(operator)

          sql = "#{initial_filter_sql} AND (#{collection_sql_rules})"
          sql += " AND #{count_comparison_sql_rule}" if operator == "are"

          sql
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
          footnotes_list.size.zero?
      end

      def initial_filter_sql
        "(searchable_data -> 'footnotes')::text <> '[]'::text"
      end

      def collection_sql_rules
        footnotes_list.map do |ops|
          q_rule = footnote_type_sql(ops)

          f_id = footnote_id(ops)
          q_rule += " AND #{footnote_id_sql(f_id)}" if f_id.present?

          "(#{q_rule})"
        end.join(" AND ")
      end

      def footnote_type_sql(ops)
        <<-eos
            searchable_data @> '{"footnotes": [{"footnote_type_id": "#{footnote_type_id(ops)}"}]}'
        eos
      end

      def footnote_type_id(ops)
        ops.keys[0].strip
      end

      def footnote_id_sql(f_id)
        <<-eos
            searchable_data @> '{"footnotes": [{"footnote_id": "#{f_id}"}]}'
        eos
      end

      def footnote_id(ops)
        ops.values[0].strip
      end

      def count_comparison_sql_rule
        <<-eos
            searchable_data #>> '{"footnotes_count"}' = '#{footnotes_list.count}'
        eos
      end

      def are_not_specified_sql_rule
        <<-eos
            searchable_data #>> '{"footnotes"}' IS NULL OR
            (searchable_data -> 'footnotes')::text = '[]'::text
        eos
      end

      def are_not_unspecified_sql_rule
        <<-eos
            searchable_data #>> '{"footnotes"}' IS NOT NULL AND
            (searchable_data -> 'footnotes')::text <> '[]'::text
        eos
      end
    end
  end
end
