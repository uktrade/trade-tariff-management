xml.tag!("oub:additional.code.description.period") do |additional_code_description_period|
  xml_data_item_v2(additional_code_description_period, "additional.code.description.period.sid", self.additional_code_description_period_sid)
  xml_data_item_v2(additional_code_description_period, "additional.code.sid", self.additional_code_sid)
  xml_data_item_v2(additional_code_description_period, "additional.code.type.id", self.additional_code_type_id)
  xml_data_item_v2(additional_code_description_period, "additional.code", self.additional_code)
  xml_data_item_v2(additional_code_description_period, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(additional_code_description_period, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
