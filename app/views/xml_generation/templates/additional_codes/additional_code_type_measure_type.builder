xml.tag!("oub:additional.code.type.measure.type") do |additional_code_type_measure_type|
  xml_data_item_v2(additional_code_type_measure_type, "measure.type.id", self.measure_type_id)
  xml_data_item_v2(additional_code_type_measure_type, "additional.code.type.id", self.additional_code_type_id)
  xml_data_item_v2(additional_code_type_measure_type, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(additional_code_type_measure_type, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
