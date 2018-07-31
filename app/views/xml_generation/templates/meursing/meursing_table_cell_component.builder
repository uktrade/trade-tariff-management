xml.tag!("oub:meursing.table.cell.component") do |meursing_table_cell_component|
  xml_data_item_v2(meursing_table_cell_component, "meursing.additional.code.sid", self.meursing_additional_code_sid)
  xml_data_item_v2(meursing_table_cell_component, "meursing.table.plan.id", self.meursing_table_plan_id)
  xml_data_item_v2(meursing_table_cell_component, "heading.number", self.heading_number)
  xml_data_item_v2(meursing_table_cell_component, "row.column.code", self.row_column_code)
  xml_data_item_v2(meursing_table_cell_component, "subheading.sequence.number", self.subheading_sequence_number)
  xml_data_item_v2(meursing_table_cell_component, "additional.code", self.additional_code)
  xml_data_item_v2(meursing_table_cell_component, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(meursing_table_cell_component, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
