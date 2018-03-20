xml.tag!("oub:additional.code.type.measure.type") do |additional_code_type_measure_type|
  additional_code_type_measure_type.tag!("oub:measure.type.id") do additional_code_type_measure_type
    xml_data_item(additional_code_type_measure_type, self.measure_type_id)
  end

  additional_code_type_measure_type.tag!("oub:additional.code.type.id") do additional_code_type_measure_type
    xml_data_item(additional_code_type_measure_type, self.additional_code_type_id)
  end

  additional_code_type_measure_type.tag!("oub:validity.start.date") do additional_code_type_measure_type
    xml_data_item(additional_code_type_measure_type, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  additional_code_type_measure_type.tag!("oub:validity.end.date") do additional_code_type_measure_type
    xml_data_item(additional_code_type_measure_type, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
