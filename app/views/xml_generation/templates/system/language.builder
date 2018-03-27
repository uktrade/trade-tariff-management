xml.tag!("oub:language") do |language|
  language.tag!("oub:language.id") do language
    xml_data_item(language, self.language_id)
  end

  language.tag!("oub:validity.start.date") do language
    xml_data_item(language, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  language.tag!("oub:validity.end.date") do language
    xml_data_item(language, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
