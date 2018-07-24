xml.tag!("oub:goods.nomenclature.group.description") do |goods_nomenclature_group_description|
  xml_data_item_v2(goods_nomenclature_group_description, "goods.nomenclature.group.type", self.goods_nomenclature_group_type)
  xml_data_item_v2(goods_nomenclature_group_description, "goods.nomenclature.group.id", self.goods_nomenclature_group_id)
  xml_data_item_v2(goods_nomenclature_group_description, "language.id", self.language_id)
  xml_data_item_v2(goods_nomenclature_group_description, "description", self.description)
end
