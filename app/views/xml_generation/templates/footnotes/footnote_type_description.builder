xml.tag!("oub:footnote.type.description") do |footnote_type_description|
  xml_data_item_v2(footnote_type_description, "footnote.type.id", self.footnote_type_id)
  xml_data_item_v2(footnote_type_description, "language.id", self.language_id)
  xml_data_item_v2(footnote_type_description, "description", self.description)
end
