xml.tag!("oub:goods.nomenclature.origin") do |goods_nomenclature_origin|
  goods_nomenclature_origin.tag!("oub:goods.nomenclature.sid") do goods_nomenclature_origin
    xml_data_item(goods_nomenclature_origin, self.goods_nomenclature_sid)
  end

  goods_nomenclature_origin.tag!("oub:derived.goods.nomenclature.item.id") do goods_nomenclature_origin
    xml_data_item(goods_nomenclature_origin, self.derived_goods_nomenclature_item_id)
  end

  goods_nomenclature_origin.tag!("oub:derived.productline.suffix") do goods_nomenclature_origin
    xml_data_item(goods_nomenclature_origin, self.derived_productline_suffix)
  end

  goods_nomenclature_origin.tag!("oub:goods.nomenclature.item.id") do goods_nomenclature_origin
    xml_data_item(goods_nomenclature_origin, self.goods_nomenclature_item_id)
  end

  goods_nomenclature_origin.tag!("oub:productline.suffix") do goods_nomenclature_origin
    xml_data_item(goods_nomenclature_origin, self.productline_suffix)
  end
end
