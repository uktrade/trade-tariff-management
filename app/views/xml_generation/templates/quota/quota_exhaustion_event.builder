xml.tag!("oub:quota.exhaustion.event") do |quota_exhaustion_event|
  quota_exhaustion_event.tag!("oub:quota.definition.sid") do quota_exhaustion_event
    xml_data_item(quota_exhaustion_event, self.quota_definition_sid)
  end

  quota_exhaustion_event.tag!("oub:occurrence.timestamp") do quota_exhaustion_event
    xml_data_item(quota_exhaustion_event, timestamp_value(self.occurrence_timestamp))
  end

  quota_exhaustion_event.tag!("oub:exhaustion.date") do quota_exhaustion_event
    xml_data_item(quota_exhaustion_event, self.exhaustion_date.try(:strftime, "%Y-%m-%d"))
  end
end
