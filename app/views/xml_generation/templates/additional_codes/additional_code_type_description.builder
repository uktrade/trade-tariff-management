xml.tag!("oub:additional.code.type.description") do |additional_code_type_description|
  additional_code_type_description.tag!("oub:additional.code.type.id") do additional_code_type_description
    xml_data_item(additional_code_type_description, self.additional_code_type_id)
  end

  additional_code_type_description.tag!("oub:language.id") do additional_code_type_description
    xml_data_item(additional_code_type_description, self.language_id)
  end

  additional_code_type_description.tag!("oub:description") do additional_code_type_description
    xml_data_item(additional_code_type_description, self.description)
  end
end
