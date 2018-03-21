xml.tag!("oub:regulation.group") do |regulation_group|
  regulation_group.tag!("oub:regulation.group.id") do regulation_group
    xml_data_item(regulation_group, self.regulation_group_id)
  end

  regulation_group.tag!("oub:validity.start.date") do regulation_group
    xml_data_item(regulation_group, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  regulation_group.tag!("oub:validity.end.date") do regulation_group
    xml_data_item(regulation_group, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
