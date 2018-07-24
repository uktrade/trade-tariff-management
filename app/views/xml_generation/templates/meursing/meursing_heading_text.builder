xml.tag!("oub:meursing.heading.text") do |meursing_heading_text|
  xml_data_item_v2(meursing_heading_text, "meursing.table.plan.id", self.meursing_table_plan_id)
  xml_data_item_v2(meursing_heading_text, "meursing.heading.number", self.meursing_heading_number)
  xml_data_item_v2(meursing_heading_text, "row.column.code", self.row_column_code)
  xml_data_item_v2(meursing_heading_text, "language.id", self.language_id)
  xml_data_item_v2(meursing_heading_text, "description", self.description)
end
