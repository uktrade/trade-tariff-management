xml.tag!("oub:prorogation.regulation.action") do |prorogation_regulation_action|
  xml_data_item_v2(prorogation_regulation_action, "prorogation.regulation.role", self.prorogation_regulation_role)
  xml_data_item_v2(prorogation_regulation_action, "prorogation.regulation.id", self.prorogation_regulation_id)
  xml_data_item_v2(prorogation_regulation_action, "prorogated.regulation.role", self.prorogated_regulation_role)
  xml_data_item_v2(prorogation_regulation_action, "prorogated.regulation.id", self.prorogated_regulation_id)
  xml_data_item_v2(prorogation_regulation_action, "prorogated.date", self.prorogated_date.strftime("%Y-%m-%d"))
end
