xml.tag!("oub:measure.partial.temporary.stop") do |measure_partial_temporary_stop|
  xml_data_item_v2(measure_partial_temporary_stop, "measure.sid", self.measure_sid)
  xml_data_item_v2(measure_partial_temporary_stop, "partial.temporary.stop.regulation.id", self.partial_temporary_stop_regulation_id)
  xml_data_item_v2(measure_partial_temporary_stop, "partial.temporary.stop.regulation.officialjournal.number", self.partial_temporary_stop_regulation_officialjournal_number)
  xml_data_item_v2(measure_partial_temporary_stop, "partial.temporary.stop.regulation.officialjournal.page", self.partial_temporary_stop_regulation_officialjournal_page)
  xml_data_item_v2(measure_partial_temporary_stop, "abrogation.regulation.id", self.abrogation_regulation_id)
  xml_data_item_v2(measure_partial_temporary_stop, "abrogation.regulation.officialjournal.number", self.abrogation_regulation_officialjournal_number)
  xml_data_item_v2(measure_partial_temporary_stop, "abrogation.regulation.officialjournal.page", self.abrogation_regulation_officialjournal_page)
  xml_data_item_v2(measure_partial_temporary_stop, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(measure_partial_temporary_stop, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
