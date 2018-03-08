xml.tag!("oub:measure.component") do |measure_component|
  measure_component.tag!("oub:measure.sid") do measure_component
    xml_data_item(measure_component, self.measure_sid)
  end

  measure_component.tag!("oub:duty.expression.id") do measure_component
    xml_data_item(measure_component, self.duty_expression_id)
  end

  measure_component.tag!("oub:duty.amount") do measure_component
    xml_data_item(measure_component, self.duty_amount)
  end

  measure_component.tag!("oub:monetary.unit.code") do measure_component
    xml_data_item(measure_component, self.monetary_unit_code)
  end

  measure_component.tag!("oub:measurement.unit.code") do measure_component
    xml_data_item(measure_component, self.measurement_unit_code)
  end

  measure_component.tag!("oub:measurement.unit.qualifier.code") do measure_component
    xml_data_item(measure_component, self.measurement_unit_qualifier_code)
  end
end
