xml.tag!("oub:measure.type.description") do |measure_type_description|
  measure_type_description.tag!("oub:measure.type.id") do measure_type_description
    xml_data_item(measure_type_description, self.measure_type_id)
  end

  measure_type_description.tag!("oub:language.id") do measure_type_description
    xml_data_item(measure_type_description, self.language_id)
  end

  measure_type_description.tag!("oub:description") do measure_type_description
    xml_data_item(measure_type_description, self.description)
  end
end
