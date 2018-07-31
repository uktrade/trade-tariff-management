xml.tag!("oub:measure.condition.component") do |measure_condition_component|
  xml_data_item_v2(measure_condition_component, "measure.condition.sid", self.measure_condition_sid)
  xml_data_item_v2(measure_condition_component, "duty.expression.id", self.duty_expression_id)
  xml_data_item_v2(measure_condition_component, "duty.amount", self.duty_amount)
  xml_data_item_v2(measure_condition_component, "monetary.unit.code", self.monetary_unit_code)
  xml_data_item_v2(measure_condition_component, "measurement.unit.code", self.measurement_unit_code)
  xml_data_item_v2(measure_condition_component, "measurement.unit.qualifier.code", self.measurement_unit_qualifier_code)
end
