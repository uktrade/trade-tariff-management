xml.tag!("oub:measure.type.series.description") do |measure_type_series_description|
  measure_type_series_description.tag!("oub:measure.type.series.id") do measure_type_series_description
    xml_data_item(measure_type_series_description, self.measure_type_series_id)
  end

  measure_type_series_description.tag!("oub:language.id") do measure_type_series_description
    xml_data_item(measure_type_series_description, self.language_id)
  end

  measure_type_series_description.tag!("oub:description") do measure_type_series_description
    xml_data_item(measure_type_series_description, self.description)
  end
end
