xml.tag!("oub:full.temporary.stop.regulation") do |full_temporary_stop_regulation|
  full_temporary_stop_regulation.tag!("oub:full.temporary.stop.regulation.role") do full_temporary_stop_regulation
    xml_data_item(full_temporary_stop_regulation, self.full_temporary_stop_regulation_role)
  end

  full_temporary_stop_regulation.tag!("oub:full.temporary.stop.regulation.id") do full_temporary_stop_regulation
    xml_data_item(full_temporary_stop_regulation, self.full_temporary_stop_regulation_id)
  end

  full_temporary_stop_regulation.tag!("oub:published.date") do full_temporary_stop_regulation
    xml_data_item(full_temporary_stop_regulation, self.published_date.strftime("%Y-%m-%d"))
  end

  full_temporary_stop_regulation.tag!("oub:officialjournal.number") do full_temporary_stop_regulation
    xml_data_item(full_temporary_stop_regulation, self.officialjournal_number)
  end

  full_temporary_stop_regulation.tag!("oub:officialjournal.page") do full_temporary_stop_regulation
    xml_data_item(full_temporary_stop_regulation, self.officialjournal_page)
  end

  full_temporary_stop_regulation.tag!("oub:explicit.abrogation.regulation.role") do full_temporary_stop_regulation
    xml_data_item(full_temporary_stop_regulation, self.explicit_abrogation_regulation_role)
  end

  full_temporary_stop_regulation.tag!("oub:explicit.abrogation.regulation.id") do full_temporary_stop_regulation
    xml_data_item(full_temporary_stop_regulation, self.explicit_abrogation_regulation_id)
  end

  full_temporary_stop_regulation.tag!("oub:replacement.indicator") do full_temporary_stop_regulation
    xml_data_item(full_temporary_stop_regulation, self.replacement_indicator)
  end

  full_temporary_stop_regulation.tag!("oub:information.text") do full_temporary_stop_regulation
    xml_data_item(full_temporary_stop_regulation, self.information_text)
  end

  full_temporary_stop_regulation.tag!("oub:approved.flag") do full_temporary_stop_regulation
    xml_data_item(full_temporary_stop_regulation, self.approved_flag)
  end

  full_temporary_stop_regulation.tag!("oub:effective.enddate") do full_temporary_stop_regulation
    xml_data_item(full_temporary_stop_regulation, self.effective_enddate.strftime("%Y-%m-%d"))
  end

  full_temporary_stop_regulation.tag!("oub:validity.start.date") do full_temporary_stop_regulation
    xml_data_item(full_temporary_stop_regulation, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  full_temporary_stop_regulation.tag!("oub:validity.end.date") do full_temporary_stop_regulation
    xml_data_item(full_temporary_stop_regulation, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
