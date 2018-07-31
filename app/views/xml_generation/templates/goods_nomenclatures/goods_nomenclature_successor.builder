xml.tag!("oub:goods.nomenclature.successor") do |goods_nomenclature_successor|
  xml_data_item_v2(goods_nomenclature_successor, "goods.nomenclature.sid", self.goods_nomenclature_sid)
  xml_data_item_v2(goods_nomenclature_successor, "absorbed.goods.nomenclature.item.id", self.absorbed_goods_nomenclature_item_id)
  xml_data_item_v2(goods_nomenclature_successor, "absorbed.productline.suffix", self.absorbed_productline_suffix)
  xml_data_item_v2(goods_nomenclature_successor, "goods.nomenclature.item.id", self.goods_nomenclature_item_id)
  xml_data_item_v2(goods_nomenclature_successor, "productline.suffix", self.productline_suffix)
end
