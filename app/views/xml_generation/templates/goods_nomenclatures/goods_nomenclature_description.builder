xml.tag!("oub:goods.nomenclature.description") do |goods_nomenclature_description|
  goods_nomenclature_description.tag!("oub:goods.nomenclature.description.period.sid") do goods_nomenclature_description
    xml_data_item(goods_nomenclature_description, self.goods_nomenclature_description_period_sid)
  end

  goods_nomenclature_description.tag!("oub:goods.nomenclature.sid") do goods_nomenclature_description
    xml_data_item(goods_nomenclature_description, self.goods_nomenclature_sid)
  end

  goods_nomenclature_description.tag!("oub:goods.nomenclature.item.id") do goods_nomenclature_description
    xml_data_item(goods_nomenclature_description, self.goods_nomenclature_item_id)
  end

  goods_nomenclature_description.tag!("oub:productline.suffix") do goods_nomenclature_description
    xml_data_item(goods_nomenclature_description, self.productline_suffix)
  end

  goods_nomenclature_description.tag!("oub:language.id") do goods_nomenclature_description
    xml_data_item(goods_nomenclature_description, self.language_id)
  end

  goods_nomenclature_description.tag!("oub:description") do goods_nomenclature_description
    xml_data_item(goods_nomenclature_description, self.description)
  end
end
