xml.tag!("oub:fts.regulation.action") do |fts_regulation_action|
  xml_data_item_v2(fts_regulation_action, "fts.regulation.role", self.fts_regulation_role)
  xml_data_item_v2(fts_regulation_action, "fts.regulation.id", self.fts_regulation_id)
  xml_data_item_v2(fts_regulation_action, "stopped.regulation.role", self.stopped_regulation_role)
  xml_data_item_v2(fts_regulation_action, "stopped.regulation.id", self.stopped_regulation_id)
end
