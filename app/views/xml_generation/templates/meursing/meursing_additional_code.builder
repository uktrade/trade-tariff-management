xml.tag!("oub:meursing.additional.code") do |meursing_additional_code|
  meursing_additional_code.tag!("oub:meursing.additional.code.sid") do meursing_additional_code
    xml_data_item(meursing_additional_code, self.meursing_additional_code_sid)
  end

  meursing_additional_code.tag!("oub:additional.code") do meursing_additional_code
    xml_data_item(meursing_additional_code, self.additional_code)
  end

  meursing_additional_code.tag!("oub:validity.start.date") do meursing_additional_code
    xml_data_item(meursing_additional_code, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  meursing_additional_code.tag!("oub:validity.end.date") do meursing_additional_code
    xml_data_item(meursing_additional_code, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
