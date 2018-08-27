module WorkbasketValueObjects
  module Shared
    class CommodityCodesAnalyzer

      attr_accessor :start_date,
                    :commodity_codes,
                    :commodity_codes_exclusions,
                    :collection,
                    :commodity_codes_detected,
                    :exclusions_detected

      def initialize(ops={})
        @collection = nil
        @start_date = ops[:start_date].present? ? ops[:start_date].to_date : nil
        @commodity_codes = ops[:commodity_codes]
        @commodity_codes_exclusions = ops[:commodity_codes_exclusions]

        setup_collection!
      end

      def commodity_codes_formatted
        clean_array(commodity_codes_detected).join(', ')
      end

      def exclusions_formatted
        clean_array(exclusions_detected).join(', ')
      end

      private

        def setup_collection!
          if list_of_codes.present?
            @commodity_codes_detected = fetch_commodity_codes(list_of_codes)

            if commodity_codes_detected.present? && commodity_codes_exclusions.present?
              @exclusions_detected = fetch_commodity_codes(commodity_codes_exclusions)

              if exclusions_detected.present?
                @commodity_codes_detected = commodity_codes_detected - exclusions_detected
              end
            end

            @collection = @commodity_codes_detected
          end

          clean_array(collection).sort do |a, b|
            a <=> b
          end
        end

        def list_of_codes
          if commodity_codes.present?
            commodity_codes.split( /\r?\n/ )
                           .map(&:strip)
                           .reject { |el| el.blank? }
                           .uniq
          end
        end

        def fetch_commodity_codes(codes_list)
          res = codes_list.map do |code|
            ::WorkbasketValueObjects::Shared::CommodityCodeParser.new(
              start_date,
              code
            ).codes
          end

          clean_array(res)
        end

        def clean_array(list)
          (list || []).flatten
                      .reject { |el| el.blank? }
                      .uniq
        end
    end
  end
end
