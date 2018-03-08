xml.tag!("oub:measure.condition") do |measure_condition|
  measure_condition.tag!("oub:measure.condition.sid") do measure_condition
    xml_data_item(measure_condition, self.measure_condition_sid)
  end

  measure_condition.tag!("oub:measure.sid") do measure_condition
    xml_data_item(measure_condition, self.measure_sid)
  end

  measure_condition.tag!("oub:condition.code") do measure_condition
    xml_data_item(measure_condition, self.condition_code)
  end

  measure_condition.tag!("oub:component.sequence.number") do measure_condition
    xml_data_item(measure_condition, self.component_sequence_number)
  end

  measure_condition.tag!("oub:condition.duty.amount") do measure_condition
    xml_data_item(measure_condition, self.condition_duty_amount)
  end

  measure_condition.tag!("oub:condition.monetary.unit.code") do measure_condition
    xml_data_item(measure_condition, self.condition_monetary_unit_code)
  end

  measure_condition.tag!("oub:condition.measurement.unit.code") do measure_condition
    xml_data_item(measure_condition, self.condition_measurement_unit_code)
  end

  measure_condition.tag!("oub:condition.measurement.unit.qualifier.code") do measure_condition
    xml_data_item(measure_condition, self.condition_measurement_unit_qualifier_code)
  end

  measure_condition.tag!("oub:action.code") do measure_condition
    xml_data_item(measure_condition, self.action_code)
  end

  measure_condition.tag!("oub:certificate.type.code") do measure_condition
    xml_data_item(measure_condition, self.certificate_type_code)
  end

  measure_condition.tag!("oub:certificate.code") do measure_condition
    xml_data_item(measure_condition, self.certificate_code)
  end
end
