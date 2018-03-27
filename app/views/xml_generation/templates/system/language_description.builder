xml.tag!("oub:language.description") do |language_description|
  language_description.tag!("oub:language.code.id") do language_description
    xml_data_item(language_description, self.language_code_id)
  end

  language_description.tag!("oub:language.id") do language_description
    xml_data_item(language_description, self.language_id)
  end

  language_description.tag!("oub:description") do language_description
    xml_data_item(language_description, self.description)
  end
end
