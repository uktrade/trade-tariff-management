xml.tag!("oub:explicit.abrogation.regulation") do |explicit_abrogation_regulation|
  xml_data_item_v2(explicit_abrogation_regulation, "explicit.abrogation.regulation.role", self.explicit_abrogation_regulation_role)
  xml_data_item_v2(explicit_abrogation_regulation, "explicit.abrogation.regulation.id", self.explicit_abrogation_regulation_id)
  xml_data_item_v2(explicit_abrogation_regulation, "published.date", self.published_date.try(:strftime, "%Y-%m-%d"))
  xml_data_item_v2(explicit_abrogation_regulation, "officialjournal.number", self.officialjournal_number)
  xml_data_item_v2(explicit_abrogation_regulation, "officialjournal.page", self.officialjournal_page)
  xml_data_item_v2(explicit_abrogation_regulation, "replacement.indicator", self.replacement_indicator)
  xml_data_item_v2(explicit_abrogation_regulation, "abrogation.date", self.abrogation_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(explicit_abrogation_regulation, "information.text", self.information_text)
  xml_data_item_v2(explicit_abrogation_regulation, "approved.flag", self.approved_flag)
end
