xml.tag!("oub:footnote.type.description") do |footnote_type_description|
  footnote_type_description.tag!("oub:footnote.type.id") do footnote_type_description
    xml_data_item(footnote_type_description, self.footnote_type_id)
  end

  footnote_type_description.tag!("oub:language.id") do footnote_type_description
    xml_data_item(footnote_type_description, self.language_id)
  end

  footnote_type_description.tag!("oub:description") do footnote_type_description
    xml_data_item(footnote_type_description, self.description)
  end
end
