xml.tag!("oub:goods.nomenclature.group.description") do |goods_nomenclature_group_description|
  goods_nomenclature_group_description.tag!("oub:goods.nomenclature.group.type") do goods_nomenclature_group_description
    xml_data_item(goods_nomenclature_group_description, self.goods_nomenclature_group_type)
  end

  goods_nomenclature_group_description.tag!("oub:goods.nomenclature.group.id") do goods_nomenclature_group_description
    xml_data_item(goods_nomenclature_group_description, self.goods_nomenclature_group_id)
  end

  goods_nomenclature_group_description.tag!("oub:language.id") do goods_nomenclature_group_description
    xml_data_item(goods_nomenclature_group_description, self.language_id)
  end

  goods_nomenclature_group_description.tag!("oub:description") do goods_nomenclature_group_description
    xml_data_item(goods_nomenclature_group_description, self.description)
  end
end
