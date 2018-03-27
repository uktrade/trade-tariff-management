xml.tag!("oub:prorogation.regulation.action") do |prorogation_regulation_action|
  prorogation_regulation_action.tag!("oub:prorogation.regulation.role") do prorogation_regulation_action
    xml_data_item(prorogation_regulation_action, self.prorogation_regulation_role)
  end

  prorogation_regulation_action.tag!("oub:prorogation.regulation.id") do prorogation_regulation_action
    xml_data_item(prorogation_regulation_action, self.prorogation_regulation_id)
  end

  prorogation_regulation_action.tag!("oub:prorogated.regulation.role") do prorogation_regulation_action
    xml_data_item(prorogation_regulation_action, self.prorogated_regulation_role)
  end

  prorogation_regulation_action.tag!("oub:prorogated.regulation.id") do prorogation_regulation_action
    xml_data_item(prorogation_regulation_action, self.prorogated_regulation_id)
  end

  prorogation_regulation_action.tag!("oub:prorogated.date") do prorogation_regulation_action
    xml_data_item(prorogation_regulation_action, self.prorogated_date.strftime("%Y-%m-%d"))
  end
end
