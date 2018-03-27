xml.tag!("oub:measurement.unit") do |measurement_unit|
  measurement_unit.tag!("oub:measurement.unit.code") do measurement_unit
    xml_data_item(measurement_unit, self.measurement_unit_code)
  end

  measurement_unit.tag!("oub:validity.start.date") do measurement_unit
    xml_data_item(measurement_unit, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  measurement_unit.tag!("oub:validity.end.date") do measurement_unit
    xml_data_item(measurement_unit, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
