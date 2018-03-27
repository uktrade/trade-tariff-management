xml.tag!("oub:additional.code") do |additional_code|
  additional_code.tag!("oub:additional.code.sid") do additional_code
    xml_data_item(additional_code, self.additional_code_sid)
  end

  additional_code.tag!("oub:additional.code.type.id") do additional_code
    xml_data_item(additional_code, self.additional_code_type_id)
  end

  additional_code.tag!("oub:additional.code") do additional_code
    xml_data_item(additional_code, self.additional_code)
  end

  additional_code.tag!("oub:validity.start.date") do additional_code
    xml_data_item(additional_code, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  additional_code.tag!("oub:validity.end.date") do additional_code
    xml_data_item(additional_code, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
