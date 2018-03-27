xml.tag!("oub:geographical.area") do |geographical_area|
  geographical_area.tag!("oub:geographical.area.sid") do geographical_area
    xml_data_item(geographical_area, self.geographical_area_sid)
  end

  geographical_area.tag!("oub:geographical.area.id") do geographical_area
    xml_data_item(geographical_area, self.geographical_area_id)
  end

  geographical_area.tag!("oub:geographical.code") do geographical_area
    xml_data_item(geographical_area, self.geographical_code)
  end

  geographical_area.tag!("oub:parent.geographical.area.group.sid") do geographical_area
    xml_data_item(geographical_area, self.parent_geographical_area_group_sid)
  end

  geographical_area.tag!("oub:validity.start.date") do geographical_area
    xml_data_item(geographical_area, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  geographical_area.tag!("oub:validity.end.date") do geographical_area
    xml_data_item(geographical_area, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
