xml.tag!("oub:regulation.role.type.description") do |regulation_role_type_description|
  xml_data_item_v2(regulation_role_type_description, "regulation.role.type.id", self.regulation_role_type_id)
  xml_data_item_v2(regulation_role_type_description, "language.id", self.language_id)
  xml_data_item_v2(regulation_role_type_description, "description", self.description)
end
