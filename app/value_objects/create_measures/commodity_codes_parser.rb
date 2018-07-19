module CreateMeasures
  class CommodityCodesParser

    attr_accessor :commodity,
                  :all_codes

    def initialize(code)
      @commodity = Commodity.by_code(code)
                            .first
    end

    def codes
      if commodity.present?
        get_commodity_children_tree(commodity)
      else
        []
      end
    end

    private

      def get_commodity_children_tree(record)
        @all_codes = []
        get_commodity_with_children(record)

        all_codes
      end

      def get_commodity_with_children(record)
        @all_codes << record.goods_nomenclature_item_id if record.declarable?
        children = record.children

        if children.present?
          children.map do |child|
            get_commodity_with_children(child)
          end
        end
      end
  end
end
