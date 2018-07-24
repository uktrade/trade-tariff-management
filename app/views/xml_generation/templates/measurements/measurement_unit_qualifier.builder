xml.tag!("oub:measurement.unit.qualifier") do |measurement_unit_qualifier|
  xml_data_item_v2(measurement_unit_qualifier, "measurement.unit.qualifier.code", self.measurement_unit_qualifier_code)
  xml_data_item_v2(measurement_unit_qualifier, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(measurement_unit_qualifier, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
