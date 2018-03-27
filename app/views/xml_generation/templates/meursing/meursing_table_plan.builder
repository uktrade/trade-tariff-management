xml.tag!("oub:meursing.table.plan") do |meursing_table_plan|
  meursing_table_plan.tag!("oub:meursing.table.plan.id") do meursing_table_plan
    xml_data_item(meursing_table_plan, self.meursing_table_plan_id)
  end

  meursing_table_plan.tag!("oub:validity.start.date") do meursing_table_plan
    xml_data_item(meursing_table_plan, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  meursing_table_plan.tag!("oub:validity.end.date") do meursing_table_plan
    xml_data_item(meursing_table_plan, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
