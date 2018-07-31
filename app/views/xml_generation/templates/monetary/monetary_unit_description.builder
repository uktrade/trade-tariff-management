xml.tag!("oub:monetary.unit.description") do |monetary_unit_description|
  xml_data_item_v2(monetary_unit_description, "monetary.unit.code", self.monetary_unit_code)
  xml_data_item_v2(monetary_unit_description, "language.id", self.language_id)
  xml_data_item_v2(monetary_unit_description, "description", self.description)
end
