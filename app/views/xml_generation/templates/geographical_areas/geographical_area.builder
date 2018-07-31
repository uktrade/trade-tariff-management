xml.tag!("oub:geographical.area") do |geographical_area|
  xml_data_item_v2(geographical_area, "geographical.area.sid", self.geographical_area_sid)
  xml_data_item_v2(geographical_area, "geographical.area.id", self.geographical_area_id)
  xml_data_item_v2(geographical_area, "geographical.code", self.geographical_code)
  xml_data_item_v2(geographical_area, "parent.geographical.area.group.sid", self.parent_geographical_area_group_sid)
  xml_data_item_v2(geographical_area, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(geographical_area, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
