module Quotas
  module SearchFilters
    class OriginExclusions < ::Shared::SearchFilters::CollectionFilterBase
      OPERATORS_WITH_REQUIRED_PARAMS = %w(
        include
        do_not_include
      ).freeze

      attr_accessor :operator,
                    :origin_exclusions

      def initialize(operator, origin_exclusions = nil)
        @operator = operator
        @origin_exclusions = if origin_exclusions.present?
                               filtered_collection_params(origin_exclusions)
                             else
                               []
                             end
      end

      def sql_rules
        return nil if required_options_are_blank?

        clause
      end

    private

      def required_options_are_blank?
        OPERATORS_WITH_REQUIRED_PARAMS.include?(operator) &&
          origin_exclusions.size.zero?
      end

      def clause
        case operator
        when "include"

          [include_clause, origin_exclusions]
        when "do_not_include"

          [include_not_clause, origin_exclusions]
        when "are_not_specified"

          specified_not_clause
        when "are_not_unspecified"

          specified_clause
        end
      end

      def include_clause
        <<~eos
          EXISTS (SELECT 1
                    FROM quota_order_numbers,
                         quota_order_number_origins,
                         quota_order_number_origin_exclusions,
                         geographical_areas
                   WHERE quota_order_numbers.quota_order_number_id = quota_definitions.quota_order_number_id
                     AND quota_order_number_origins.quota_order_number_sid = quota_order_numbers.quota_order_number_sid
                     AND quota_order_number_origin_exclusions.quota_order_number_origin_sid = quota_order_number_origins.quota_order_number_origin_sid
                     AND geographical_areas.geographical_area_sid = quota_order_number_origin_exclusions.excluded_geographical_area_sid
                     AND geographical_areas.geographical_area_id in ?)
        eos
      end

      def include_not_clause
        <<~eos
          (
          NOT EXISTS (SELECT 1
                        FROM quota_order_numbers,
                             quota_order_number_origins,
                             quota_order_number_origin_exclusions,
                             geographical_areas
                       WHERE quota_order_numbers.quota_order_number_id = quota_definitions.quota_order_number_id
                         AND quota_order_number_origins.quota_order_number_sid = quota_order_numbers.quota_order_number_sid
                         AND quota_order_number_origin_exclusions.quota_order_number_origin_sid = quota_order_number_origins.quota_order_number_origin_sid
                         AND geographical_areas.geographical_area_sid = quota_order_number_origin_exclusions.excluded_geographical_area_sid
                         AND geographical_areas.geographical_area_id in ?)
          AND
          EXISTS (SELECT 1
                    FROM quota_order_numbers,
                         quota_order_number_origins,
                         quota_order_number_origin_exclusions
                   WHERE quota_order_numbers.quota_order_number_id = quota_definitions.quota_order_number_id
                     AND quota_order_number_origins.quota_order_number_sid = quota_order_numbers.quota_order_number_sid
                     AND quota_order_number_origin_exclusions.quota_order_number_origin_sid = quota_order_number_origins.quota_order_number_origin_sid)
          )
        eos
      end

      def specified_not_clause
        <<~eos
          NOT EXISTS (SELECT 1
                        FROM quota_order_numbers,
                             quota_order_number_origins,
                             quota_order_number_origin_exclusions
                       WHERE quota_order_numbers.quota_order_number_id = quota_definitions.quota_order_number_id
                         AND quota_order_number_origins.quota_order_number_sid = quota_order_numbers.quota_order_number_sid
                         AND quota_order_number_origin_exclusions.quota_order_number_origin_sid = quota_order_number_origins.quota_order_number_origin_sid)
        eos
      end

      def specified_clause
        <<~eos
          EXISTS (SELECT 1
                    FROM quota_order_numbers,
                         quota_order_number_origins,
                         quota_order_number_origin_exclusions
                   WHERE quota_order_numbers.quota_order_number_id = quota_definitions.quota_order_number_id
                     AND quota_order_number_origins.quota_order_number_sid = quota_order_numbers.quota_order_number_sid
                     AND quota_order_number_origin_exclusions.quota_order_number_origin_sid = quota_order_number_origins.quota_order_number_origin_sid)
        eos
      end
    end
  end
end
