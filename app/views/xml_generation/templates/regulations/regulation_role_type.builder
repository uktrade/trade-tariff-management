xml.tag!("oub:regulation.role.type") do |regulation_role_type|
  regulation_role_type.tag!("oub:regulation.role.type.id") do regulation_role_type
    xml_data_item(regulation_role_type, self.regulation_role_type_id)
  end

  regulation_role_type.tag!("oub:validity.start.date") do regulation_role_type
    xml_data_item(regulation_role_type, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  regulation_role_type.tag!("oub:validity.end.date") do regulation_role_type
    xml_data_item(regulation_role_type, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
