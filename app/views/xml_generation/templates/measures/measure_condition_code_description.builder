xml.tag!("measure.condition.code.description") do |measure_condition_code_description|
  measure_condition_code_description.tag!("oub:condition.code") do measure_condition_code_description
    xml_data_item(measure_condition_code_description, self.condition_code)
  end

  measure_condition_code_description.tag!("oub:language.id") do measure_condition_code_description
    xml_data_item(measure_condition_code_description, self.language_id)
  end

  measure_condition_code_description.tag!("oub:description") do measure_condition_code_description
    xml_data_item(measure_condition_code_description, self.description)
  end
end
