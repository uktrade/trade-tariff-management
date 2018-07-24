xml.tag!("oub:footnote.association.meursing.heading") do |footnote_association_meursing_heading|
  xml_data_item_v2(footnote_association_meursing_heading, "meursing.table.plan.id", self.meursing_table_plan_id)
  xml_data_item_v2(footnote_association_meursing_heading, "meursing.heading.number", self.meursing_heading_number)
  xml_data_item_v2(footnote_association_meursing_heading, "row.column.code", self.row_column_code)
  xml_data_item_v2(footnote_association_meursing_heading, "footnote.type", self.footnote_type)
  xml_data_item_v2(footnote_association_meursing_heading, "footnote.id", self.footnote_id)
  xml_data_item_v2(footnote_association_meursing_heading, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(footnote_association_meursing_heading, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
