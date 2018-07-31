xml.tag!("oub:measure.type.description") do |measure_type_description|
  xml_data_item_v2(measure_type_description, "measure.type.id", self.measure_type_id)
  xml_data_item_v2(measure_type_description, "language.id", self.language_id)
  xml_data_item_v2(measure_type_description, "description", self.description)
end
