xml.tag!("measure.condition.component") do |measure_condition_component|
  measure_condition_component.tag!("oub:measure.condition.sid") do measure_condition_component
    xml_data_item(measure_condition_component, self.measure_condition_sid)
  end

  measure_condition_component.tag!("oub:duty.expression.id") do measure_condition_component
    xml_data_item(measure_condition_component, self.duty_expression_id)
  end

  measure_condition_component.tag!("oub:duty.amount") do measure_condition_component
    xml_data_item(measure_condition_component, self.duty_amount)
  end

  measure_condition_component.tag!("oub:monetary.unit.code") do measure_condition_component
    xml_data_item(measure_condition_component, self.monetary_unit_code)
  end

  measure_condition_component.tag!("oub:measurement.unit.code") do measure_condition_component
    xml_data_item(measure_condition_component, self.measurement_unit_code)
  end

  measure_condition_component.tag!("oub:measurement.unit.qualifier.code") do measure_condition_component
    xml_data_item(measure_condition_component, self.measurement_unit_qualifier_code)
  end
end
