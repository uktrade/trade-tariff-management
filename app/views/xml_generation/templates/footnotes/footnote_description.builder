xml.tag!("oub:footnote.description") do |footnote_description|
  xml_data_item_v2(footnote_description, "footnote.description.period.sid", self.footnote_description_period_sid)
  xml_data_item_v2(footnote_description, "language.id", self.language_id)
  xml_data_item_v2(footnote_description, "footnote.type.id", self.footnote_type_id)
  xml_data_item_v2(footnote_description, "footnote.id", self.footnote_id)
  xml_data_item_v2(footnote_description, "description", self.description)
end
