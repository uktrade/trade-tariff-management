xml.tag!("oub:duty.expression") do |duty_expression|
  xml_data_item_v2(duty_expression, "duty.expression.id", self.duty_expression_id)
  xml_data_item_v2(duty_expression, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(duty_expression, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  xml_data_item_v2(duty_expression, "duty.amount.applicability.code", self.duty_amount_applicability_code)
  xml_data_item_v2(duty_expression, "measurement.unit.applicability.code", self.measurement_unit_applicability_code)
  xml_data_item_v2(duty_expression, "monetary.unit.applicability.code", self.monetary_unit_applicability_code)
end
