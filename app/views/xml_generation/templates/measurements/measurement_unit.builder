xml.tag!("oub:measurement.unit") do |measurement_unit|
  xml_data_item_v2(measurement_unit, "measurement.unit.code", self.measurement_unit_code)
  xml_data_item_v2(measurement_unit, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(measurement_unit, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
