xml.tag!("oub:measurement.unit.description") do |measurement_unit_description|
  measurement_unit_description.tag!("oub:measurement.unit.code") do measurement_unit_description
    xml_data_item(measurement_unit_description, self.measurement_unit_code)
  end

  measurement_unit_description.tag!("oub:language.id") do measurement_unit_description
    xml_data_item(measurement_unit_description, self.language_id)
  end

  measurement_unit_description.tag!("oub:description") do measurement_unit_description
    xml_data_item(measurement_unit_description, self.description)
  end
end
