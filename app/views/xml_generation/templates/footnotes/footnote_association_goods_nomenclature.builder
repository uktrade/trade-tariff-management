xml.tag!("oub:footnote.association.goods.nomenclature") do |footnote_association_goods_nomenclature|
  xml_data_item_v2(footnote_association_goods_nomenclature, "goods.nomenclature.sid", self.goods_nomenclature_sid)
  xml_data_item_v2(footnote_association_goods_nomenclature, "footnote.type", self.footnote_type)
  xml_data_item_v2(footnote_association_goods_nomenclature, "footnote.id", self.footnote_id)
  xml_data_item_v2(footnote_association_goods_nomenclature, "goods.nomenclature.item.id", self.goods_nomenclature_item_id)
  xml_data_item_v2(footnote_association_goods_nomenclature, "productline.suffix", self.productline_suffix)
  xml_data_item_v2(footnote_association_goods_nomenclature, "validity.start.date", self.self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(footnote_association_goods_nomenclature, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
