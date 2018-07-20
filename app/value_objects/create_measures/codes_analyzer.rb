module CreateMeasures
  class CodesAnalyzer

    attr_accessor :commodity_codes,
                  :additional_codes,
                  :commodity_codes_exclusions

    def initialize(ops={})
      @commodity_codes = ops[:commodity_codes]
      @additional_codes = ops[:additional_codes]
      @commodity_codes_exclusions = ops[:commodity_codes_exclusions]
    end

    def collection
      res = nil

      if list_of_codes.present?
        res = if commodity_codes.present?
          codes = fetch_commodity_codes(list_of_codes)

          if codes.present? && commodity_codes_exclusions.present?
            exclusions = fetch_commodity_codes(commodity_codes_exclusions)
            codes = codes - exclusions if exclusions.present?
          end

          codes
        else
          fetch_additional_codes
        end
      end

      clean_array(res)
    end

    private

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
          ::CreateMeasures::CommodityCodeParser.new(
            code
          ).codes
        end

        clean_array(res)
      end

      def fetch_additional_codes
        list_of_codes.map do |code|
          AdditionalCode.by_code(code)
        end.map(&:code)
      end

      def clean_array(list)
        list.flatten
            .reject { |el| el.blank? }
            .uniq
      end
  end
end
