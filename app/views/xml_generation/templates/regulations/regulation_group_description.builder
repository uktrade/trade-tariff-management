xml.tag!("oub:regulation.group.description") do |regulation_group_description|
  regulation_group_description.tag!("oub:regulation.group.id") do regulation_group_description
    xml_data_item(regulation_group_description, self.regulation_group_id)
  end

  regulation_group_description.tag!("oub:language.id") do regulation_group_description
    xml_data_item(regulation_group_description, self.language_id)
  end

  regulation_group_description.tag!("oub:description") do regulation_group_description
    xml_data_item(regulation_group_description, self.description)
  end
end
