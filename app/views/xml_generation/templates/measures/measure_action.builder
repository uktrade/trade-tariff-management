xml.tag!("oub:measure.action") do |measure_action|
  xml_data_item_v2(measure_action, "action.code", self.action_code)
  xml_data_item_v2(measure_action, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(measure_action, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
