xml.tag!("oub:measurement") do |measurement|
  measurement.tag!("oub:measurement.unit.code") do measurement
    xml_data_item(measurement, self.measurement_unit_code)
  end

  measurement.tag!("oub:measurement.unit.qualifier.code") do measurement
    xml_data_item(measurement, self.measurement_unit_qualifier_code)
  end

  measurement.tag!("oub:validity.start.date") do measurement
    xml_data_item(measurement, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  measurement.tag!("oub:validity.end.date") do measurement
    xml_data_item(measurement, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
