xml.tag!("oub:goods.nomenclature.successor") do |goods_nomenclature_successor|
  goods_nomenclature_successor.tag!("oub:goods.nomenclature.sid") do goods_nomenclature_successor
    xml_data_item(goods_nomenclature_successor, self.goods_nomenclature_sid)
  end

  goods_nomenclature_successor.tag!("oub:absorbed.goods.nomenclature.item.id") do goods_nomenclature_successor
    xml_data_item(goods_nomenclature_successor, self.absorbed_goods_nomenclature_item_id)
  end

  goods_nomenclature_successor.tag!("oub:absorbed.productline.suffix") do goods_nomenclature_successor
    xml_data_item(goods_nomenclature_successor, self.absorbed_productline_suffix)
  end

  goods_nomenclature_successor.tag!("oub:goods.nomenclature.item.id") do goods_nomenclature_successor
    xml_data_item(goods_nomenclature_successor, self.goods_nomenclature_item_id)
  end

  goods_nomenclature_successor.tag!("oub:productline.suffix") do goods_nomenclature_successor
    xml_data_item(goods_nomenclature_successor, self.productline_suffix)
  end
end
