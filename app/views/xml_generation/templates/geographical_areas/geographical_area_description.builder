xml.tag!("oub:geographical.area.description") do |geographical_area_description|
  geographical_area_description.tag!("oub:geographical.area.description.period.sid") do geographical_area_description
    xml_data_item(geographical_area_description, self.geographical_area_description_period_sid)
  end

  geographical_area_description.tag!("oub:geographical.area.sid") do geographical_area_description
    xml_data_item(geographical_area_description, self.geographical_area_sid)
  end

  geographical_area_description.tag!("oub:geographical.area.id") do geographical_area_description
    xml_data_item(geographical_area_description, self.geographical_area_id)
  end

  geographical_area_description.tag!("oub:language.id") do geographical_area_description
    xml_data_item(geographical_area_description, self.language_id)
  end

  geographical_area_description.tag!("oub:description") do geographical_area_description
    xml_data_item(geographical_area_description, self.description)
  end
end
