xml.tag!("oub:measure.action") do |measure_action|
  measure_action.tag!("oub:action.code") do measure_action
    xml_data_item(measure_action, self.action_code)
  end

  measure_action.tag!("oub:validity.start.date") do measure_action
    xml_data_item(measure_action, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  measure_action.tag!("oub:validity.end.date") do measure_action
    xml_data_item(measure_action, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
