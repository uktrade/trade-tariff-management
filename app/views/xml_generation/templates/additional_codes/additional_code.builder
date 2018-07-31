xml.tag!("oub:additional.code") do |additional_code|
  xml_data_item_v2(additional_code, "additional.code.sid", self.additional_code_sid)
  xml_data_item_v2(additional_code, "additional.code.type.id", self.additional_code_type_id)
  xml_data_item_v2(additional_code, "additional.code", self.additional_code)
  xml_data_item_v2(additional_code, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(additional_code, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
