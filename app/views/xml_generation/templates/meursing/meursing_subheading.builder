xml.tag!("oub:meursing.subheading") do |meursing_subheading|
  xml_data_item_v2(meursing_subheading, "meursing.table.plan.id", self.meursing_table_plan_id)
  xml_data_item_v2(meursing_subheading, "meursing.heading.number", self.meursing_heading_number)
  xml_data_item_v2(meursing_subheading, "row.column.code", self.row_column_code)
  xml_data_item_v2(meursing_subheading, "subheading.sequence.number", self.subheading_sequence_number)
  xml_data_item_v2(meursing_subheading, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(meursing_subheading, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  xml_data_item_v2(meursing_subheading, "description", self.description)
end
