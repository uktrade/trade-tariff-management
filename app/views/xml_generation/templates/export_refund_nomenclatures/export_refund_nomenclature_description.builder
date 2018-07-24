xml.tag!("oub:export.refund.nomenclature.description") do |export_refund_nomenclature_description|
  xml_data_item_v2(export_refund_nomenclature_description, "export.refund.nomenclature.description.period.sid", self.export_refund_nomenclature_description_period_sid)
  xml_data_item_v2(export_refund_nomenclature_description, "language.id", self.language_id)
  xml_data_item_v2(export_refund_nomenclature_description, "export.refund.nomenclature.sid", self.export_refund_nomenclature_sid)
  xml_data_item_v2(export_refund_nomenclature_description, "goods.nomenclature.item.id", self.goods_nomenclature_item_id)
  xml_data_item_v2(export_refund_nomenclature_description, "additional.code.type", self.additional_code_type)
  xml_data_item_v2(export_refund_nomenclature_description, "export.refund.code", self.export_refund_code)
  xml_data_item_v2(export_refund_nomenclature_description, "productline.suffix", self.productline_suffix)
  xml_data_item_v2(export_refund_nomenclature_description, "description", self.description)
end
