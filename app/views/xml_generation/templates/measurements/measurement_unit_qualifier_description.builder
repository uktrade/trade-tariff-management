xml.tag!("oub:measurement.unit.qualifier.description") do |measurement_unit_qualifier_description|
  xml_data_item_v2(measurement_unit_qualifier_description, "measurement.unit.qualifier.code", self.measurement_unit_qualifier_code)
  xml_data_item_v2(measurement_unit_qualifier_description, "language.id", self.language_id)
  xml_data_item_v2(measurement_unit_qualifier_description, "description", self.description)
end
