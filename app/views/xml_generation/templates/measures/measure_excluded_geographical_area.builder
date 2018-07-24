xml.tag!("oub:measure.excluded.geographical.area") do |measure_excluded_geographical_area|
  xml_data_item_v2(measure_excluded_geographical_area, "measure.sid", self.measure_sid)
  xml_data_item_v2(measure_excluded_geographical_area, "excluded.geographical.area", self.excluded_geographical_area)
  xml_data_item_v2(measure_excluded_geographical_area, "geographical.area.sid", self.geographical_area_sid)
end
