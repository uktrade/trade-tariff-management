xml.tag!("oub:measure.action.description") do |measure_action_description|
  xml_data_item_v2(measure_action_description, "action.code", self.action_code)
  xml_data_item_v2(measure_action_description, "language.id", self.language_id)
  xml_data_item_v2(measure_action_description, "description", self.description)
end
