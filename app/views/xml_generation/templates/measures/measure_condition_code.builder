xml.tag!("oub:measure.condition.code") do |measure_condition_code|
  measure_condition_code.tag!("oub:condition.code") do measure_condition_code
    xml_data_item(measure_condition_code, self.condition_code)
  end

  measure_condition_code.tag!("oub:validity.start.date") do measure_condition_code
    xml_data_item(measure_condition_code, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  measure_condition_code.tag!("oub:validity.end.date") do measure_condition_code
    xml_data_item(measure_condition_code, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
