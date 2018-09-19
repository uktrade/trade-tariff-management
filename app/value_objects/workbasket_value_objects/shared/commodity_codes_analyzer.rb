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
            if commodity_codes_exclusions.present?
              # get excluded declarable commodity
              @exclusions_detected = fetch_commodity_codes(commodity_codes_exclusions) || []
              @commodity_codes_detected = []

              list_of_codes.each do |code|

                if chapter?(code)
                  # if code is a chapter, then check all headings within
                  chapter = Chapter.by_code(code).all.first
                  chapter.headings.each do |heading|
                    heading_code = heading.goods_nomenclature_item_id
                    if heading_in?(heading_code, commodity_codes_exclusions)
                      #if heading has excluded commodity, get declarable commodity within heading
                      current_codes = ::WorkbasketValueObjects::Shared::CommodityCodeParser.
                          new(start_date, heading_code).
                          codes
                      #add all commodities that not excluded
                      @commodity_codes_detected = commodity_codes_detected + (current_codes - exclusions_detected)
                    else
                      #add heading completely if has no excluded commodities
                      @commodity_codes_detected = commodity_codes_detected + Array::wrap(heading_code)
                    end

                  end

                else

                  #if code is not a chapter, get all declarable commodities
                  current_codes = ::WorkbasketValueObjects::Shared::CommodityCodeParser.
                      new(start_date, code).
                      codes
                  #and add all declarable commodities without excluded
                  @commodity_codes_detected = commodity_codes_detected + (current_codes - exclusions_detected)

                end
              end

            else
              #if has no excluded commodities, apply all codes without changes or expanding
              @commodity_codes_detected = list_of_codes
            end
            @collection = commodity_codes_detected
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

        def chapter?(code)
          code.end_with? '00000000'
        end

        def heading_for?(heading, code)
          code.gsub(/0(?=0*$)/, '').start_with? heading.gsub(/0(?=0*$)/, '')
        end

        def heading_in?(heading, list)
          list.any? do |code|
            heading_for?(heading, code)
          end
        end
    end
  end
end
