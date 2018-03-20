xml.tag!("oub:regulation.role.type.description") do |regulation_role_type_description|
  regulation_role_type_description.tag!("oub:regulation.role.type.id") do regulation_role_type_description
    xml_data_item(regulation_role_type_description, self.regulation_role_type_id)
  end

  regulation_role_type_description.tag!("oub:language.id") do regulation_role_type_description
    xml_data_item(regulation_role_type_description, self.language_id)
  end

  regulation_role_type_description.tag!("oub:description") do regulation_role_type_description
    xml_data_item(regulation_role_type_description, self.description)
  end
end
