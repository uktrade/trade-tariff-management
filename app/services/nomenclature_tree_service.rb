class NomenclatureTreeService
  def self.nomenclature_tree(nomenclature_code)

    nomenclature_children_sql = <<-SQL
      SELECT gn.goods_nomenclature_sid,
             gn.goods_nomenclature_item_id,
             gn.producline_suffix,
             (select number_indents
              from goods_nomenclature_indents
              where goods_nomenclature_sid = gn.goods_nomenclature_sid
              order by oid desc
              limit 1),
             (select description
              from goods_nomenclature_descriptions
              where goods_nomenclature_sid = gn.goods_nomenclature_sid
              and status = 'published'
              order by oid desc
              limit 1)
      from goods_nomenclatures gn
      where (gn.validity_end_date is null or gn.validity_end_date >= current_date)
        and gn.validity_start_date <= current_date
        and gn.goods_nomenclature_item_id like ?
      order by gn.goods_nomenclature_item_id, gn.producline_suffix;
    SQL

    root_node = nil
    current_path = []
    Sequel::Model.db.fetch(nomenclature_children_sql, "#{nomenclature_code[0..3]}______").each do |nomenclature|
      new_node = TreeNode.new(nomenclature[:goods_nomenclature_item_id], nomenclature)
      if root_node == nil
        if nomenclature[:producline_suffix] != "10"
          root_node = new_node
          current_path = [root_node]
        else
          # item is a heading group - do nothing (e.g. see 7101000000 which has an item suffix 10 as a group heading)
        end
      elsif (nomenclature[:number_indents] -1 == current_path[-1].content[:number_indents])
        # new_node is a child of the current path end
        current_path[-1].children << new_node
        current_path << new_node
      elsif (nomenclature[:number_indents] == current_path[-1].content[:number_indents])
        # new_node is a sibling of the current path end
        current_path[-2].children << new_node
        current_path[-1] = new_node
      elsif (nomenclature[:number_indents] < current_path[-1].content[:number_indents])
        # new_node is a sibling of a higher point in the current path
        jump_up = current_path[-1].content[:number_indents] - nomenclature[:number_indents]
        current_path[-2-jump_up].children << new_node
        current_path[-1-jump_up..-1] = new_node
      end
    end

    root_node
  end
end
