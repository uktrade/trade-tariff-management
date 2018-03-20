xml.tag!("oub:prorogation.regulation") do |prorogation_regulation|
  prorogation_regulation.tag!("oub:prorogation.regulation.role") do prorogation_regulation
    xml_data_item(prorogation_regulation, self.prorogation_regulation_role)
  end

  prorogation_regulation.tag!("oub:prorogation.regulation.id") do prorogation_regulation
    xml_data_item(prorogation_regulation, self.prorogation_regulation_id)
  end

  prorogation_regulation.tag!("oub:published.date") do prorogation_regulation
    xml_data_item(prorogation_regulation, self.published_date.strftime("%Y-%m-%d"))
  end

  prorogation_regulation.tag!("oub:officialjournal.number") do prorogation_regulation
    xml_data_item(prorogation_regulation, self.officialjournal_number)
  end

  prorogation_regulation.tag!("oub:officialjournal.page") do prorogation_regulation
    xml_data_item(prorogation_regulation, self.officialjournal_page)
  end

  prorogation_regulation.tag!("oub:replacement.indicator") do prorogation_regulation
    xml_data_item(prorogation_regulation, self.replacement_indicator)
  end

  prorogation_regulation.tag!("oub:information.text") do prorogation_regulation
    xml_data_item(prorogation_regulation, self.information_text)
  end

  prorogation_regulation.tag!("oub:approved.flag") do prorogation_regulation
    xml_data_item(prorogation_regulation, self.approved_flag)
  end
end
