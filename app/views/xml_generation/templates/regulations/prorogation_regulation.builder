xml.tag!("oub:prorogation.regulation") do |prorogation_regulation|
  xml_data_item_v2(prorogation_regulation, "prorogation.regulation.role", self.prorogation_regulation_role)
  xml_data_item_v2(prorogation_regulation, "prorogation.regulation.id", self.prorogation_regulation_id)
  xml_data_item_v2(prorogation_regulation, "published.date", self.published_date.try(:strftime, "%Y-%m-%d"))
  xml_data_item_v2(prorogation_regulation, "officialjournal.number", self.officialjournal_number)
  xml_data_item_v2(prorogation_regulation, "officialjournal.page", self.officialjournal_page)
  xml_data_item_v2(prorogation_regulation, "replacement.indicator", self.replacement_indicator)
  xml_data_item_v2(prorogation_regulation, "information.text", self.information_text)
  xml_data_item_v2(prorogation_regulation, "approved.flag", flag_format(self.approved_flag))
end
