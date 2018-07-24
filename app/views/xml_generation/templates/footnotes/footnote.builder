xml.tag!("oub:footnote") do |footnote|
  xml_data_item_v2(footnote, "footnote.type.id", self.footnote_type_id)
  xml_data_item_v2(footnote, "footnote.id", self.footnote_id)
  xml_data_item_v2(footnote, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(footnote, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
