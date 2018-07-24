xml.tag!("oub:additional.code.type.description") do |additional_code_type_description|
  xml_data_item_v2(additional_code_type_description, "additional.code.type.id", self.additional_code_type_id)
  xml_data_item_v2(additional_code_type_description, "language.id", self.language_id)
  xml_data_item_v2(additional_code_type_description, "description", self.description)
end
