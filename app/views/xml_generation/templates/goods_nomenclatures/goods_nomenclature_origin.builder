xml.tag!("oub:goods.nomenclature.origin") do |goods_nomenclature_origin|
  xml_data_item_v2(goods_nomenclature_origin, "goods.nomenclature.sid", self.goods_nomenclature_sid)
  xml_data_item_v2(goods_nomenclature_origin, "derived.goods.nomenclature.item.id", self.derived_goods_nomenclature_item_id)
  xml_data_item_v2(goods_nomenclature_origin, "derived.productline.suffix", self.derived_productline_suffix)
  xml_data_item_v2(goods_nomenclature_origin, "goods.nomenclature.item.id", self.goods_nomenclature_item_id)
  xml_data_item_v2(goods_nomenclature_origin, "productline.suffix", self.productline_suffix)
end
