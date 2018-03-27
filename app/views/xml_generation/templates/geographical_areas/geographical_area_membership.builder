xml.tag!("oub:geographical.area.membership") do |geographical_area_membership|
  geographical_area_membership.tag!("oub:geographical.area.sid") do geographical_area_membership
    xml_data_item(geographical_area_membership, self.geographical_area_sid)
  end

  geographical_area_membership.tag!("oub:geographical.area.group.sid") do geographical_area_membership
    xml_data_item(geographical_area_membership, self.geographical_area_group_sid)
  end

  geographical_area_membership.tag!("oub:validity.start.date") do geographical_area_membership
    xml_data_item(geographical_area_membership, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  geographical_area_membership.tag!("oub:validity.end.date") do geographical_area_membership
    xml_data_item(geographical_area_membership, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
