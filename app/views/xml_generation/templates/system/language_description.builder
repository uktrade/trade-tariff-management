xml.tag!("oub:language.description") do |language_description|
  xml_data_item_v2(language_description, "language.code.id", self.language_code_id)
  xml_data_item_v2(language_description, "language.id", self.language_id)
  xml_data_item_v2(language_description, "description", self.description)
end
