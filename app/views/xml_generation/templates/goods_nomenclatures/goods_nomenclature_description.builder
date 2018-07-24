xml.tag!("oub:goods.nomenclature.description") do |goods_nomenclature_description|
  xml_data_item_v2(goods_nomenclature_description, "goods.nomenclature.description.period.sid", self.goods_nomenclature_description_period_sid)
  xml_data_item_v2(goods_nomenclature_description, "goods.nomenclature.sid", self.goods_nomenclature_sid)
  xml_data_item_v2(goods_nomenclature_description, "goods.nomenclature.item.id", self.goods_nomenclature_item_id)
  xml_data_item_v2(goods_nomenclature_description, "productline.suffix", self.productline_suffix)
  xml_data_item_v2(goods_nomenclature_description, "language.id", self.language_id)
  xml_data_item_v2(goods_nomenclature_description, "description", self.description)
end
