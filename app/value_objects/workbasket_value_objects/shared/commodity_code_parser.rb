module WorkbasketValueObjects
  module Shared
    class CommodityCodeParser

      def self.get_child_code_leaves(code:, query_date:)
        # Retrieve the commodity codes from each "leaf" in the commodity code tree from a given node
        GoodsNomenclature.fetch(expand_commodity_tree_sql(code: code, query_date: query_date)).all.map do |item|
          item[:goods_nomenclature_item_id]
        end.sort || []
      end

      private_class_method def self.expand_commodity_tree_sql(code:, query_date:)
        # substitute _ instead 0 in the end of code
        code_mask = code.gsub(/0(?=0*$)/, '_')

        # select all actual (validity dates check) child (LIKE check) declarable (producline_suffix check) goods nomenclatures
        # that have no children (subselect check - last LIKE is about parent - child)
        <<~END_SQL.gsub(/\s+/, ' ').strip
          SELECT g.goods_nomenclature_item_id
            FROM goods_nomenclatures g
           WHERE g.goods_nomenclature_item_id LIKE '#{code_mask}'
             AND g.producline_suffix = '80'
             AND g.validity_start_date <= '#{query_date.strftime('%Y-%m-%d')}'
             AND (g.validity_end_date >= '#{query_date.strftime('%Y-%m-%d')}' OR g.validity_end_date IS NULL)
             AND NOT EXISTS (
               SELECT 1
                 FROM goods_nomenclatures c
                WHERE c.goods_nomenclature_sid != g.goods_nomenclature_sid
                  AND c.goods_nomenclature_item_id LIKE '#{code_mask}'
                  AND c.producline_suffix = '80'
                  AND c.validity_start_date <= '#{query_date.strftime('%Y-%m-%d')}'
                  AND (c.validity_end_date >= '#{query_date.strftime('%Y-%m-%d')}' OR c.validity_end_date IS NULL)
                  AND c.goods_nomenclature_item_id LIKE regexp_replace(g.goods_nomenclature_item_id, '0(?=0*$)', '_', 'g')
                            )
        END_SQL
      end
    end
  end
end
