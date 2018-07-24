xml.tag!("oub:measure.component") do |measure_component|
  xml_data_item_v2(measure_component, "measure.sid", self.measure_sid)
  xml_data_item_v2(measure_component, "duty.expression.id", self.duty_expression_id)
  xml_data_item_v2(measure_component, "duty.amount", self.duty_amount)
  xml_data_item_v2(measure_component, "monetary.unit.code", self.monetary_unit_code)
  xml_data_item_v2(measure_component, "measurement.unit.code", self.measurement_unit_code)
  xml_data_item_v2(measure_component, "measurement.unit.qualifier.code", self.measurement_unit_qualifier_code)
end
