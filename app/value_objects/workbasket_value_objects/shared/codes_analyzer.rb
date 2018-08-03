module WorkbasketValueObjects
  module Shared
    class CodesAnalyzer

      attr_accessor :start_date,
                    :commodity_codes,
                    :additional_codes,
                    :commodity_codes_exclusions,
                    :collection,
                    :commodity_codes_detected,
                    :exclusions_detected,
                    :additional_codes_detected

      def initialize(ops={})
        @collection = nil
        @start_date = ops[:start_date]
        @commodity_codes = ops[:commodity_codes]
        @additional_codes = ops[:additional_codes]
        @commodity_codes_exclusions = ops[:commodity_codes_exclusions]

        setup_collection!
      end

      def commodity_codes_formatted
        clean_array(commodity_codes_detected).join(', ')
      end

      def exclusions_formatted
        clean_array(exclusions_detected).join(', ')
      end

      def additional_codes_formatted
        clean_array(additional_codes_detected).join(', ')
      end

      private

        def setup_collection!
          if list_of_codes.present?
            @collection = if commodity_codes_mode?
              @commodity_codes_detected = fetch_commodity_codes(list_of_codes)

              if commodity_codes_detected.present? && commodity_codes_exclusions.present?
                @exclusions_detected = fetch_commodity_codes(commodity_codes_exclusions)

                if exclusions_detected.present?
                  @commodity_codes_detected = commodity_codes_detected - exclusions_detected
                end
              end

              @commodity_codes_detected
            else
              fetch_additional_codes
            end
          end

          clean_array(collection).sort do |a, b|
            a <=> b
          end
        end

        def commodity_codes_mode?
          commodity_codes.present?
        end

        def list_of_codes
          if commodity_codes.present?
            commodity_codes.split( /\r?\n/ )
          else
            additional_codes.split(",")
          end.map(&:strip)
             .reject { |el| el.blank? }
             .uniq
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

        def fetch_additional_codes
          @additional_codes_detected = list_of_codes.map do |code|
            AdditionalCode.by_code(code)
          end.reject { |el| el.blank? }
             .map(&:code)
        end

        def clean_array(list)
          (list || []).flatten
                      .reject { |el| el.blank? }
                      .uniq
        end
    end
  end
end
