xml.tag!("oub:measure.type.series") do |measure_type_series|
  xml_data_item_v2(measure_type_series, "measure.type.series.id", self.measure_type_series_id)
  xml_data_item_v2(measure_type_series, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(measure_type_series, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  xml_data_item_v2(measure_type_series, "measure.type.combination", self.measure_type_combination)
end
