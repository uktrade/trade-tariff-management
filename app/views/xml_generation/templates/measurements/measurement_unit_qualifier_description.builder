xml.tag!("oub:measurement.unit.qualifier.description") do |measurement_unit_qualifier_description|
  measurement_unit_qualifier_description.tag!("oub:measurement.unit.qualifier.code") do measurement_unit_qualifier_description
    xml_data_item(measurement_unit_qualifier_description, self.measurement_unit_qualifier_code)
  end

  measurement_unit_qualifier_description.tag!("oub:language.id") do measurement_unit_qualifier_description
    xml_data_item(measurement_unit_qualifier_description, self.language_id)
  end

  measurement_unit_qualifier_description.tag!("oub:description") do measurement_unit_qualifier_description
    xml_data_item(measurement_unit_qualifier_description, self.description)
  end
end
