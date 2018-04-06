xml.tag!("oub:additional.code.description.period") do |additional_code_description_period|
  additional_code_description_period.tag!("oub:additional.code.description.period.sid") do additional_code_description_period
    xml_data_item(additional_code_description_period, self.additional_code_description_period_sid)
  end

  additional_code_description_period.tag!("oub:additional.code.sid") do additional_code_description_period
    xml_data_item(additional_code_description_period, self.additional_code_sid)
  end

  additional_code_description_period.tag!("oub:additional.code.type.id") do additional_code_description_period
    xml_data_item(additional_code_description_period, self.additional_code_type_id)
  end

  additional_code_description_period.tag!("oub:additional.code") do additional_code_description_period
    xml_data_item(additional_code_description_period, self.additional_code)
  end

  additional_code_description_period.tag!("oub:validity.start.date") do additional_code_description_period
    xml_data_item(additional_code_description_period, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  additional_code_description_period.tag!("oub:validity.end.date") do additional_code_description_period
    xml_data_item(additional_code_description_period, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
