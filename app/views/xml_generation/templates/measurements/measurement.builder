xml.tag!("oub:measurement") do |measurement|
  xml_data_item_v2(measurement, "measurement.unit.code", self.measurement_unit_code)
  xml_data_item_v2(measurement, "measurement.unit.qualifier.code", self.measurement_unit_qualifier_code)
  xml_data_item_v2(measurement, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(measurement, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
