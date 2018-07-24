xml.tag!("oub:measurement.unit.description") do |measurement_unit_description|
  xml_data_item_v2(measurement_unit_description, "measurement.unit.code", self.measurement_unit_code)
  xml_data_item_v2(measurement_unit_description, "language.id", self.language_id)
  xml_data_item_v2(measurement_unit_description, "description", self.description)
end
