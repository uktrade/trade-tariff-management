xml.tag!("oub:base.regulation") do |base_regulation|
  base_regulation.tag!("oub:base.regulation.role") do base_regulation
    xml_data_item(base_regulation, self.base_regulation_role)
  end

  base_regulation.tag!("oub:base.regulation.id") do base_regulation
    xml_data_item(base_regulation, self.base_regulation_id)
  end

  base_regulation.tag!("oub:published.date") do base_regulation
    xml_data_item(base_regulation, self.published_date.strftime("%Y-%m-%d"))
  end

  base_regulation.tag!("oub:officialjournal.number") do base_regulation
    xml_data_item(base_regulation, self.officialjournal_number)
  end

  base_regulation.tag!("oub:officialjournal.page") do base_regulation
    xml_data_item(base_regulation, self.officialjournal_page)
  end

  base_regulation.tag!("oub:validity.start.date") do base_regulation
    xml_data_item(base_regulation, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  base_regulation.tag!("oub:validity.end.date") do base_regulation
    xml_data_item(base_regulation, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end

  base_regulation.tag!("oub:effective.end.date") do base_regulation
    xml_data_item(base_regulation, self.effective_end_date.try(:strftime, "%Y-%m-%d"))
  end

  base_regulation.tag!("oub:community.code") do base_regulation
    xml_data_item(base_regulation, self.community_code)
  end

  base_regulation.tag!("oub:regulation.group.id") do base_regulation
    xml_data_item(base_regulation, self.regulation_group_id)
  end

  base_regulation.tag!("oub:antidumping.regulation.role") do base_regulation
    xml_data_item(base_regulation, self.antidumping_regulation_role)
  end

  base_regulation.tag!("oub:related.antidumping.regulation.id") do base_regulation
    xml_data_item(base_regulation, self.related_antidumping_regulation_id)
  end

  base_regulation.tag!("oub:complete.abrogation.regulation.role") do base_regulation
    xml_data_item(base_regulation, self.complete_abrogation_regulation_role)
  end

  base_regulation.tag!("oub:complete.abrogation.regulation.id") do base_regulation
    xml_data_item(base_regulation, self.complete_abrogation_regulation_id)
  end

  base_regulation.tag!("oub:explicit.abrogation.regulation.role") do base_regulation
    xml_data_item(base_regulation, self.explicit_abrogation_regulation_role)
  end

  base_regulation.tag!("oub:explicit.abrogation.regulation.id") do base_regulation
    xml_data_item(base_regulation, self.explicit_abrogation_regulation_id)
  end

  base_regulation.tag!("oub:replacement.indicator") do base_regulation
    xml_data_item(base_regulation, self.replacement_indicator)
  end

  base_regulation.tag!("oub:stopped.flag") do base_regulation
    xml_data_item(base_regulation, self.stopped_flag)
  end

  base_regulation.tag!("oub:information.text") do base_regulation
    xml_data_item(base_regulation, self.information_text)
  end

  base_regulation.tag!("oub:approved.flag") do base_regulation
    xml_data_item(base_regulation, self.approved_flag)
  end
end
