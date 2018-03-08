xml.tag!("oub:duty.expression") do |duty_expression|
  duty_expression.tag!("oub:duty.expression.id") do duty_expression
    xml_data_item(duty_expression, self.duty_expression_id)
  end

  duty_expression.tag!("oub:validity.start.date") do duty_expression
    xml_data_item(duty_expression, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  duty_expression.tag!("oub:validity.end.date") do duty_expression
    xml_data_item(duty_expression, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end

  duty_expression.tag!("oub:duty.amount.applicability.code") do duty_expression
    xml_data_item(duty_expression, self.duty_amount_applicability_code)
  end

  duty_expression.tag!("oub:measurement.unit.applicability.code") do duty_expression
    xml_data_item(duty_expression, self.measurement_unit_applicability_code)
  end

  duty_expression.tag!("oub:monetary.unit.applicability.code") do duty_expression
    xml_data_item(duty_expression, self.monetary_unit_applicability_code)
  end
end
