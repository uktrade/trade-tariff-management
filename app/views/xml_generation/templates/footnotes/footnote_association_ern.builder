xml.tag!("oub:footnote.association.ern") do |footnote_association_ern|
  xml_data_item_v2(footnote_association_ern, "export.refund.nomenclature.sid", self.export_refund_nomenclature_sid)
  xml_data_item_v2(footnote_association_ern, "footnote.type", self.footnote_type)
  xml_data_item_v2(footnote_association_ern, "footnote.id", self.footnote_id)
  xml_data_item_v2(footnote_association_ern, "goods.nomenclature.item.id", self.goods_nomenclature_item_id)
  xml_data_item_v2(footnote_association_ern, "additional.code.type", self.additional_code_type)
  xml_data_item_v2(footnote_association_ern, "export.refund.code", self.export.refund.code)
  xml_data_item_v2(footnote_association_ern, "productline.suffix", self.productline_suffix)
  xml_data_item_v2(footnote_association_ern, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(footnote_association_ern, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
