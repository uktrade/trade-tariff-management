xml.tag!("oub:geographical.area.description.period") do |geographical_area_description_period|
  geographical_area_description_period.tag!("oub:geographical.area.description.period.sid") do geographical_area_description_period
    xml_data_item(geographical_area_description_period, self.geographical_area_description_period_sid)
  end

  geographical_area_description_period.tag!("oub:geographical.area.sid") do geographical_area_description_period
    xml_data_item(geographical_area_description_period, self.geographical_area_sid)
  end

  geographical_area_description_period.tag!("oub:geographical.area.id") do geographical_area_description_period
    xml_data_item(geographical_area_description_period, self.geographical_area_id)
  end

  geographical_area_description_period.tag!("oub:validity.start.date") do geographical_area_description_period
    xml_data_item(geographical_area_description_period, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  geographical_area_description_period.tag!("oub:validity.end.date") do geographical_area_description_period
    xml_data_item(geographical_area_description_period, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
