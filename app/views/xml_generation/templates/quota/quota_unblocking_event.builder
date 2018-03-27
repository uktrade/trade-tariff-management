xml.tag!("oub:quota.unblocking.event") do |quota_unblocking_event|
  quota_unblocking_event.tag!("oub:quota.definition.sid") do quota_unblocking_event
    xml_data_item(quota_unblocking_event, self.quota_definition_sid)
  end

  quota_unblocking_event.tag!("oub:occurrence.timestamp") do quota_unblocking_event
    xml_data_item(quota_unblocking_event, timestamp_value(self.occurrence_timestamp))
  end

  quota_unblocking_event.tag!("oub:unblocking.date") do quota_unblocking_event
    xml_data_item(quota_unblocking_event, self.unblocking_date.try(:strftime, "%Y-%m-%d"))
  end
end
