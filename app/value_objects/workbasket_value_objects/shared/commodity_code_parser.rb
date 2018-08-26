module WorkbasketValueObjects
  module Shared
    class CommodityCodeParser

      attr_accessor :commodity,
                    :start_date,
                    :all_codes

      def initialize(start_date, code)
        @start_date = start_date

        @commodity = GoodsNomenclature.by_code(code) # also include declarable headings
                              .with_validity_end_date_nil_or_after(start_date)
                              .all
                              .sort do |a, b|
          a.producline_suffix.to_i <=> b.producline_suffix.to_i
        end.first
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
            children.select do |child|
              child.validity_end_date.blank? || child.validity_end_date > start_date
            end.map do |child|
              get_commodity_with_children(child)
            end
          end
        end
    end
  end
end
