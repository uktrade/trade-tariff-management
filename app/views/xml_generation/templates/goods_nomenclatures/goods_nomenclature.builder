xml.tag!("oub:goods.nomenclature") do |goods_nomenclature|
  xml_data_item_v2(goods_nomenclature, "goods.nomenclature.sid", self.goods_nomenclature_sid)
  xml_data_item_v2(goods_nomenclature, "goods.nomenclature.item.id", self.goods_nomenclature_item_id)
  xml_data_item_v2(goods_nomenclature, "producline.suffix", self.producline_suffix)
  xml_data_item_v2(goods_nomenclature, "statistical.indicator", self.statistical_indicator)
  xml_data_item_v2(goods_nomenclature, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(goods_nomenclature, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
