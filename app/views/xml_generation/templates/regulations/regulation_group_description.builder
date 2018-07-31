xml.tag!("oub:regulation.group.description") do |regulation_group_description|
  xml_data_item_v2(regulation_group_description, "regulation.group.id", self.regulation_group_id)
  xml_data_item_v2(regulation_group_description, "language.id", self.language_id)
  xml_data_item_v2(regulation_group_description, "description", self.description)
end
