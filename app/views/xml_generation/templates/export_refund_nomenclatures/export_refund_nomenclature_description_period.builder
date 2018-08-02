xml.tag!("oub:export.refund.nomenclature.description.period") do |export_refund_nomenclature_description_period|
  xml_data_item_v2(export_refund_nomenclature_description_period, "export.refund.nomenclature.description.period.sid", self.export_refund_nomenclature_description_period_sid)
  xml_data_item_v2(export_refund_nomenclature_description_period, "export.refund.nomenclature.sid", self.export_refund_nomenclature_sid)
  xml_data_item_v2(export_refund_nomenclature_description_period, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(export_refund_nomenclature_description_period, "goods.nomenclature.item.id", self.goods_nomenclature_item_id)
  xml_data_item_v2(export_refund_nomenclature_description_period, "additional.code.type", self.additional_code_type)
  xml_data_item_v2(export_refund_nomenclature_description_period, "export.refund.code", self.export_refund_code)
  xml_data_item_v2(export_refund_nomenclature_description_period, "productline.suffix", self.productline_suffix)
end
