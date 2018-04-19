xml.tag!("oub:explicit.abrogation.regulation") do |explicit_abrogation_regulation|
  explicit_abrogation_regulation.tag!("oub:explicit.abrogation.regulation.role") do explicit_abrogation_regulation
    xml_data_item(explicit_abrogation_regulation, self.explicit_abrogation_regulation_role)
  end

  explicit_abrogation_regulation.tag!("oub:explicit.abrogation.regulation.id") do explicit_abrogation_regulation
    xml_data_item(explicit_abrogation_regulation, self.explicit_abrogation_regulation_id)
  end

  explicit_abrogation_regulation.tag!("oub:published.date") do explicit_abrogation_regulation
    xml_data_item(explicit_abrogation_regulation, self.published_date.try(:strftime, "%Y-%m-%d"))
  end

  explicit_abrogation_regulation.tag!("oub:officialjournal.number") do explicit_abrogation_regulation
    xml_data_item(explicit_abrogation_regulation, self.officialjournal_number)
  end

  explicit_abrogation_regulation.tag!("oub:officialjournal.page") do explicit_abrogation_regulation
    xml_data_item(explicit_abrogation_regulation, self.officialjournal_page)
  end

  explicit_abrogation_regulation.tag!("oub:replacement.indicator") do explicit_abrogation_regulation
    xml_data_item(explicit_abrogation_regulation, self.replacement_indicator)
  end

  explicit_abrogation_regulation.tag!("oub:abrogation.date") do explicit_abrogation_regulation
    xml_data_item(explicit_abrogation_regulation, self.abrogation_date.strftime("%Y-%m-%d"))
  end

  explicit_abrogation_regulation.tag!("oub:information.text") do explicit_abrogation_regulation
    xml_data_item(explicit_abrogation_regulation, self.information_text)
  end

  explicit_abrogation_regulation.tag!("oub:approved.flag") do explicit_abrogation_regulation
    xml_data_item(explicit_abrogation_regulation, self.approved_flag)
  end
end
