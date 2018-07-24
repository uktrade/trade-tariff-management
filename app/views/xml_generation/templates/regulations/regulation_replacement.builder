xml.tag!("oub:regulation.replacement") do |regulation_replacement|
  xml_data_item_v2(regulation_replacement, "replacing.regulation.role", self.replacing_regulation_role)
  xml_data_item_v2(regulation_replacement, "replacing.regulation.id", self.replacing_regulation_id)
  xml_data_item_v2(regulation_replacement, "replaced.regulation.role", self.replaced_regulation_role)
  xml_data_item_v2(regulation_replacement, "replaced.regulation.id", self.replaced_regulation_id)
  xml_data_item_v2(regulation_replacement, "measure.type.id", self.measure_type_id)
  xml_data_item_v2(regulation_replacement, "geographical.area.id", self.geographical_area_id)
  xml_data_item_v2(regulation_replacement, "chapter.heading", self.chapter.heading)
end
