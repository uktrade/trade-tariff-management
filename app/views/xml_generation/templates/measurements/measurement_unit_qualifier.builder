xml.tag!("oub:measurement.unit.qualifier") do |measurement_unit_qualifier|
  measurement_unit_qualifier.tag!("oub:measurement.unit.qualifier.code") do measurement_unit_qualifier
    xml_data_item(measurement_unit_qualifier, self.measurement_unit_qualifier_code)
  end

  measurement_unit_qualifier.tag!("oub:validity.start.date") do measurement_unit_qualifier
    xml_data_item(measurement_unit_qualifier, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  measurement_unit_qualifier.tag!("oub:validity.end.date") do measurement_unit_qualifier
    xml_data_item(measurement_unit_qualifier, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
