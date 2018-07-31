xml.tag!("oub:measure.condition.code") do |measure_condition_code|
  xml_data_item_v2(measure_condition_code, "condition.code", self.condition_code)
  xml_data_item_v2(measure_condition_code, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(measure_condition_code, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
