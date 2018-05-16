xml.tag!("oub:complete.abrogation.regulation") do |complete_abrogation_regulation|
  complete_abrogation_regulation.tag!("oub:complete.abrogation.regulation.role") do complete_abrogation_regulation
    xml_data_item(complete_abrogation_regulation, self.complete_abrogation_regulation_role)
  end

  complete_abrogation_regulation.tag!("oub:complete.abrogation.regulation.id") do complete_abrogation_regulation
    xml_data_item(complete_abrogation_regulation, self.complete_abrogation_regulation_id)
  end

  complete_abrogation_regulation.tag!("oub:published.date") do complete_abrogation_regulation
    xml_data_item(complete_abrogation_regulation, self.published_date.try(:strftime, "%Y-%m-%d"))
  end

  complete_abrogation_regulation.tag!("oub:officialjournal.number") do complete_abrogation_regulation
    xml_data_item(complete_abrogation_regulation, self.officialjournal_number)
  end

  complete_abrogation_regulation.tag!("oub:officialjournal.page") do complete_abrogation_regulation
    xml_data_item(complete_abrogation_regulation, self.officialjournal_page)
  end

  complete_abrogation_regulation.tag!("oub:replacement.indicator") do complete_abrogation_regulation
    xml_data_item(complete_abrogation_regulation, self.replacement_indicator)
  end

  complete_abrogation_regulation.tag!("oub:information.text") do complete_abrogation_regulation
    xml_data_item(complete_abrogation_regulation, self.information_text)
  end

  complete_abrogation_regulation.tag!("oub:approved.flag") do complete_abrogation_regulation
    xml_data_item(complete_abrogation_regulation, self.approved_flag)
  end
end
