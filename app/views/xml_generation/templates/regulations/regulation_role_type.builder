xml.tag!("oub:regulation.role.type") do |regulation_role_type|
  xml_data_item_v2(regulation_role_type, "regulation.role.type.id", self.regulation_role_type_id)
  xml_data_item_v2(regulation_role_type, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(regulation_role_type, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
