xml.tag!("oub:geographical.area.membership") do |geographical_area_membership|
  xml_data_item_v2(geographical_area_membership, "geographical.area.sid", self.geographical_area_sid)
  xml_data_item_v2(geographical_area_membership, "geographical.area.group.sid", self.geographical_area_group_sid)
  xml_data_item_v2(geographical_area_membership, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(geographical_area_membership, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
