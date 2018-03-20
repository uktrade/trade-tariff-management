xml.tag!("oub:footnote.description") do |footnote_description|
  footnote_description.tag!("oub:footnote.description.period.sid") do footnote_description
    xml_data_item(footnote_description, self.footnote_description_period_sid)
  end

  footnote_description.tag!("oub:language.id") do footnote_description
    xml_data_item(footnote_description, self.language_id)
  end

  footnote_description.tag!("oub:footnote.type.id") do footnote_description
    xml_data_item(footnote_description, self.footnote_type_id)
  end

  footnote_description.tag!("oub:footnote.id") do footnote_description
    xml_data_item(footnote_description, self.footnote_id)
  end

  footnote_description.tag!("oub:description") do footnote_description
    xml_data_item(footnote_description, self.description)
  end
end
