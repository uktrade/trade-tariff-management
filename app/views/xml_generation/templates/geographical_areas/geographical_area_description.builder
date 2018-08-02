xml.tag!("oub:geographical.area.description") do |geographical_area_description|
  xml_data_item_v2(geographical_area_description, "geographical.area.description.period.sid", self.geographical_area_description_period_sid)
  xml_data_item_v2(geographical_area_description, "language.id", self.language_id)
  xml_data_item_v2(geographical_area_description, "geographical.area.sid", self.geographical_area_sid)
  xml_data_item_v2(geographical_area_description, "geographical.area.id", self.geographical_area_id)
  xml_data_item_v2(geographical_area_description, "description", self.description)
end
