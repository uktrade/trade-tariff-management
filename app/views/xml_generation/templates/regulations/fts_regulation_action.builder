xml.tag!("oub:fts.regulation.action") do |fts_regulation_action|
  fts_regulation_action.tag!("oub:fts.regulation.role") do fts_regulation_action
    xml_data_item(fts_regulation_action, self.fts_regulation_role)
  end

  fts_regulation_action.tag!("oub:fts.regulation.id") do fts_regulation_action
    xml_data_item(fts_regulation_action, self.fts_regulation_id)
  end

  fts_regulation_action.tag!("oub:stopped.regulation.role") do fts_regulation_action
    xml_data_item(fts_regulation_action, self.stopped_regulation_role)
  end

  fts_regulation_action.tag!("oub:stopped.regulation.id") do fts_regulation_action
    xml_data_item(fts_regulation_action, self.stopped_regulation_id)
  end
end
