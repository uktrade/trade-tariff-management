xml.tag!("oub:footnote.type") do |footnote_type|
  xml_data_item_v2(footnote_type, "footnote.type.id", self.footnote_type_id)
  xml_data_item_v2(footnote_type, "application.code", self.application_code)
  xml_data_item_v2(footnote_type, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(footnote_type, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
