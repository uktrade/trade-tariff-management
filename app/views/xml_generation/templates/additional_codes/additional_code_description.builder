xml.tag!("oub:additional.code.description") do |additional_code_description|
  xml_data_item_v2(additional_code_description, "additional.code.description.period.sid", self.additional_code_description_period_sid)
  xml_data_item_v2(additional_code_description, "language.id", self.language_id)
  xml_data_item_v2(additional_code_description, "additional.code.sid", self.additional_code_sid)
  xml_data_item_v2(additional_code_description, "additional.code.type.id", self.additional_code_type_id)
  xml_data_item_v2(additional_code_description, "additional.code", self.additional_code)
  xml_data_item_v2(additional_code_description, "description", self.description)
end
