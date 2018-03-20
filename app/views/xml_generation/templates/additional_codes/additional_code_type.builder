xml.tag!("oub:additional.code.type") do |additional_code_type|
  additional_code_type.tag!("oub:additional.code.type.id") do additional_code_type
    xml_data_item(additional_code_type, self.additional_code_type_id)
  end

  additional_code_type.tag!("oub:application.code") do additional_code_type
    xml_data_item(additional_code_type, self.application_code)
  end

  additional_code_type.tag!("oub:meursing.table.plan.id") do additional_code_type
    xml_data_item(additional_code_type, self.meursing_table_plan_id)
  end

  additional_code_type.tag!("oub:validity.start.date") do additional_code_type
    xml_data_item(additional_code_type, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  additional_code_type.tag!("oub:validity.end.date") do additional_code_type
    xml_data_item(additional_code_type, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
