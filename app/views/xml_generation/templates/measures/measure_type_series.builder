xml.tag!("oub:measure.type.series") do |measure_type_series|
  measure_type_series.tag!("oub:measure.type.series.id") do measure_type_series
    xml_data_item(measure_type_series, self.measure_type_series_id)
  end

  measure_type_series.tag!("oub:measure.type.combination") do measure_type_series
    xml_data_item(measure_type_series, self.measure_type_combination)
  end

  measure_type_series.tag!("oub:validity.start.date") do measure_type_series
    xml_data_item(measure_type_series, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  measure_type_series.tag!("oub:validity.end.date") do measure_type_series
    xml_data_item(measure_type_series, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
