xml.tag!("oub:measure.condition") do |measure_condition|
  xml_data_item_v2(measure_condition, "measure.condition.sid", self.measure_condition_sid)
  xml_data_item_v2(measure_condition, "measure.sid", self.measure_sid)
  xml_data_item_v2(measure_condition, "condition.code", self.condition_code)
  xml_data_item_v2(measure_condition, "component.sequence.number", self.component_sequence_number)
  xml_data_item_v2(measure_condition, "condition.duty.amount", self.condition_duty_amount)
  xml_data_item_v2(measure_condition, "condition.monetary.unit.code", self.condition_monetary_unit_code)
  xml_data_item_v2(measure_condition, "ondition.measurement.unit.code", self.condition_measurement_unit_code)
  xml_data_item_v2(measure_condition, "condition.measurement.unit.qualifier.code", self.condition_measurement_unit_qualifier_code)
  xml_data_item_v2(measure_condition, "action.code", self.action_code)
  xml_data_item_v2(measure_condition, "certificate.type.code", self.certificate_type_code)
  xml_data_item_v2(measure_condition, "certificate.code", self.certificate_code)
end
