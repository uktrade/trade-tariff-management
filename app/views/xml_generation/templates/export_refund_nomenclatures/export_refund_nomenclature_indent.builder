xml.tag!("oub:export.refund.nomenclature.indents") do |export_refund_nomenclature_indents|
  xml_data_item_v2(export_refund_nomenclature_indents, "export.refund.nomenclature.indents.sid", self.export_refund_nomenclature_indents_sid)
  xml_data_item_v2(export_refund_nomenclature_indents, "export.refund.nomenclature.sid", self.export_refund_nomenclature_sid)
  xml_data_item_v2(export_refund_nomenclature_indents, "number.export.refund.nomenclature.indents", self.number_export_refund_nomenclature_indents)
  xml_data_item_v2(export_refund_nomenclature_indents, "goods.nomenclature.item.id", self.goods_nomenclature_item_id)
  xml_data_item_v2(export_refund_nomenclature_indents, "additional.code.type", self.additional_code_type)
  xml_data_item_v2(export_refund_nomenclature_indents, "export.refund.code", self.export_refund_code)
  xml_data_item_v2(export_refund_nomenclature_indents, "productline.suffix", self.productline_suffix)
  xml_data_item_v2(export_refund_nomenclature_indents, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(export_refund_nomenclature_indents, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
