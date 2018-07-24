xml.tag!("oub:language") do |language|
  xml_data_item_v2(language, "language.id", self.language_id)
  xml_data_item_v2(language, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(language, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
