xml.tag!("oub:geographical.area.description.period") do |geographical_area_description_period|
  xml_data_item_v2(geographical_area_description_period, "geographical.area.description.period.sid", self.geographical_area_description_period_sid)
  xml_data_item_v2(geographical_area_description_period, "geographical.area.sid", self.geographical_area_sid)
  xml_data_item_v2(geographical_area_description_period, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(geographical_area_description_period, "geographical.area.id", self.geographical_area_id)
end
