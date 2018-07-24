xml.tag!("oub:measure.type.series.description") do |measure_type_series_description|
  xml_data_item_v2(measure_type_series_description, "measure.type.series.id", self.measure_type_series_id)
  xml_data_item_v2(measure_type_series_description, "language.id", self.language_id)
  xml_data_item_v2(measure_type_series_description, "description", self.description)
end
