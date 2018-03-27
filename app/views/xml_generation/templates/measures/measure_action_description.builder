xml.tag!("oub:measure.action.description") do |measure_action_description|
  measure_action_description.tag!("oub:action.code") do measure_action_description
    xml_data_item(measure_action_description, self.action_code)
  end

  measure_action_description.tag!("oub:language.id") do measure_action_description
    xml_data_item(measure_action_description, self.language_id)
  end

  measure_action_description.tag!("oub:description") do measure_action_description
    xml_data_item(measure_action_description, self.description)
  end
end
