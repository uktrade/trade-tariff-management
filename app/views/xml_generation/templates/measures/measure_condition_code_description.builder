xml.tag!("oub:measure.condition.code.description") do |measure_condition_code_description|
  xml_data_item_v2(measure_condition_code_description, "condition.code", self.condition_code)
  xml_data_item_v2(measure_condition_code_description, "language.id", self.language_id)
  xml_data_item_v2(measure_condition_code_description, "description", self.description)
end
