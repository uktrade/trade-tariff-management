xml.tag!("oub:meursing.table.plan") do |meursing_table_plan|
  xml_data_item_v2(meursing_table_plan, "meursing.table.plan.id", self.meursing_table_plan_id)
  xml_data_item_v2(meursing_table_plan, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(meursing_table_plan, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
