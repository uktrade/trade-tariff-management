xml.tag!("oub:measure.partial.temporary.stop") do |measure_partial_temporary_stop|
  measure_partial_temporary_stop.tag!("oub:measure.sid") do measure_partial_temporary_stop
    xml_data_item(measure_partial_temporary_stop, self.measure_sid)
  end

  measure_partial_temporary_stop.tag!("oub:partial.temporary.stop.regulation.id") do measure_partial_temporary_stop
    xml_data_item(measure_partial_temporary_stop, self.partial_temporary_stop_regulation_id)
  end

  measure_partial_temporary_stop.tag!("oub:partial.temporary.stop.regulation.officialjournal.number") do measure_partial_temporary_stop
    xml_data_item(measure_partial_temporary_stop, self.partial_temporary_stop_regulation_officialjournal_number)
  end

  measure_partial_temporary_stop.tag!("oub:partial.temporary.stop.regulation.officialjournal.page") do measure_partial_temporary_stop
    xml_data_item(measure_partial_temporary_stop, self.partial_temporary_stop_regulation_officialjournal_page)
  end

  measure_partial_temporary_stop.tag!("oub:abrogation.regulation.id") do measure_partial_temporary_stop
    xml_data_item(measure_partial_temporary_stop, self.abrogation_regulation_id)
  end

  measure_partial_temporary_stop.tag!("oub:abrogation.regulation.officialjournal.number") do measure_partial_temporary_stop
    xml_data_item(measure_partial_temporary_stop, self.abrogation_regulation_officialjournal_number)
  end

  measure_partial_temporary_stop.tag!("oub:abrogation.regulation.officialjournal.page") do measure_partial_temporary_stop
    xml_data_item(measure_partial_temporary_stop, self.abrogation_regulation_officialjournal_page)
  end

  measure_partial_temporary_stop.tag!("oub:validity.start.date") do measure_partial_temporary_stop
    xml_data_item(measure_partial_temporary_stop, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  measure_partial_temporary_stop.tag!("oub:validity.end.date") do measure_partial_temporary_stop
    xml_data_item(measure_partial_temporary_stop, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
