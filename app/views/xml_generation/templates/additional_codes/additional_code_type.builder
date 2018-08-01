xml.tag!("oub:additional.code.type") do |additional_code_type|
  xml_data_item_v2(additional_code_type, "additional.code.type.id", self.additional_code_type_id)
  xml_data_item_v2(additional_code_type, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(additional_code_type, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  xml_data_item_v2(additional_code_type, "application.code", self.application_code)
  xml_data_item_v2(additional_code_type, "meursing.table.plan.id", self.meursing_table_plan_id)
end
