xml.tag!("oub:regulation.group") do |regulation_group|
  xml_data_item_v2(regulation_group, "regulation.group.id", self.regulation_group_id)
  xml_data_item_v2(regulation_group, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(regulation_group, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
