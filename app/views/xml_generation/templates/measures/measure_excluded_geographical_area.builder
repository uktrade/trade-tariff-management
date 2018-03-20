xml.tag!("oub:measure.excluded.geographical.area") do |measure_excluded_geographical_area|
  measure_excluded_geographical_area.tag!("oub:measure.sid") do measure_excluded_geographical_area
    xml_data_item(measure_excluded_geographical_area, self.measure_sid)
  end

  measure_excluded_geographical_area.tag!("oub:excluded.geographical.area") do measure_excluded_geographical_area
    xml_data_item(measure_excluded_geographical_area, self.excluded_geographical_area)
  end

  measure_excluded_geographical_area.tag!("oub:geographical.area.sid") do measure_excluded_geographical_area
    xml_data_item(measure_excluded_geographical_area, self.geographical_area_sid)
  end
end
