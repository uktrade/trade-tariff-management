xml.tag!("oub:modification.regulation") do |modification_regulation|
  modification_regulation.tag!("oub:modification.regulation.role") do modification_regulation
    xml_data_item(modification_regulation, self.modification_regulation_role)
  end

  modification_regulation.tag!("oub:modification.regulation.id") do modification_regulation
    xml_data_item(modification_regulation, self.modification_regulation_id)
  end

  modification_regulation.tag!("oub:published.date") do modification_regulation
    xml_data_item(modification_regulation, self.published_date.strftime("%Y-%m-%d"))
  end

  modification_regulation.tag!("oub:officialjournal.number") do modification_regulation
    xml_data_item(modification_regulation, self.officialjournal_number)
  end

  modification_regulation.tag!("oub:officialjournal.page") do modification_regulation
    xml_data_item(modification_regulation, self.officialjournal_page)
  end

  modification_regulation.tag!("oub:validity.start.date") do modification_regulation
    xml_data_item(modification_regulation, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  modification_regulation.tag!("oub:validity.end.date") do modification_regulation
    xml_data_item(modification_regulation, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end

  modification_regulation.tag!("oub:effective.end.date") do modification_regulation
    xml_data_item(modification_regulation, self.effective_end_date.try(:strftime, "%Y-%m-%d"))
  end

  modification_regulation.tag!("oub:base.regulation.role") do base_regulation
    xml_data_item(modification_regulation, self.base_regulation_role)
  end

  modification_regulation.tag!("oub:base.regulation.id") do base_regulation
    xml_data_item(modification_regulation, self.base_regulation_id)
  end

  modification_regulation.tag!("oub:complete.abrogation.regulation.role") do modification_regulation
    xml_data_item(modification_regulation, self.complete_abrogation_regulation_role)
  end

  modification_regulation.tag!("oub:complete.abrogation.regulation.id") do modification_regulation
    xml_data_item(modification_regulation, self.complete_abrogation_regulation_id)
  end

  modification_regulation.tag!("oub:explicit.abrogation.regulation.role") do modification_regulation
    xml_data_item(modification_regulation, self.explicit_abrogation_regulation_role)
  end

  modification_regulation.tag!("oub:explicit.abrogation.regulation.id") do modification_regulation
    xml_data_item(modification_regulation, self.explicit_abrogation_regulation_id)
  end

  modification_regulation.tag!("oub:replacement.indicator") do modification_regulation
    xml_data_item(modification_regulation, self.replacement_indicator)
  end

  modification_regulation.tag!("oub:stopped.flag") do modification_regulation
    xml_data_item(modification_regulation, self.stopped_flag)
  end

  modification_regulation.tag!("oub:information.text") do modification_regulation
    xml_data_item(modification_regulation, self.information_text)
  end

  modification_regulation.tag!("oub:approved.flag") do modification_regulation
    xml_data_item(modification_regulation, self.approved_flag)
  end
end
