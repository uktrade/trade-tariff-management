xml.tag!("oub:export.refund.nomenclature") do |export_refund_nomenclature|
  xml_data_item_v2(export_refund_nomenclature, "export.refund.nomenclature.sid", self.export_refund_nomenclature_sid)
  xml_data_item_v2(export_refund_nomenclature, "goods.nomenclature.item.id", self.goods_nomenclature_item_id)
  xml_data_item_v2(export_refund_nomenclature, "additional.code.type", self.additional_code_type)
  xml_data_item_v2(export_refund_nomenclature, "export.refund.code", self.export_refund_code)
  xml_data_item_v2(export_refund_nomenclature, "productline.suffix", self.productline_suffix)
  xml_data_item_v2(export_refund_nomenclature, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(export_refund_nomenclature, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  xml_data_item_v2(export_refund_nomenclature, "goods.nomenclature.sid", self.goods_nomenclature_sid)
end
