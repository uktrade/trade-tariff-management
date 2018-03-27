xml.tag!("oub:additional.code.description") do |additional_code_description|
  additional_code_description.tag!("oub:additional.code.description.period.sid") do additional_code_description
    xml_data_item(additional_code_description, self.additional_code_description_period_sid)
  end

  additional_code_description.tag!("oub:language.id") do additional_code_description
    xml_data_item(additional_code_description, self.language_id)
  end

  additional_code_description.tag!("oub:additional.code.sid") do additional_code_description
    xml_data_item(additional_code_description, self.additional_code_sid)
  end

  additional_code_description.tag!("oub:additional.code.type.id") do additional_code_description
    xml_data_item(additional_code_description, self.additional_code_type_id)
  end

  additional_code_description.tag!("oub:additional.code") do additional_code_description
    xml_data_item(additional_code_description, self.additional_code)
  end

  additional_code_description.tag!("oub:description") do additional_code_description
    xml_data_item(additional_code_description, self.description)
  end
end
