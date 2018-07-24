xml.tag!("oub:footnote.description.period") do |footnote_description_period|
  xml_data_item_v2(footnote_description_period, "footnote.description.period.sid", self.footnote_description_period_sid)
  xml_data_item_v2(footnote_description_period, "footnote.type.id", self.footnote_type_id)
  xml_data_item_v2(footnote_description_period, "footnote.id", self.footnote_id)
  xml_data_item_v2(footnote_description_period, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(footnote_description_period, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
