xml.tag!("oub:quota.critical.event") do |quota_critical_event|
  quota_critical_event.tag!("oub:quota.definition.sid") do quota_critical_event
    xml_data_item(quota_critical_event, self.quota_definition_sid)
  end

  quota_critical_event.tag!("oub:occurrence.timestamp") do quota_critical_event
    xml_data_item(quota_critical_event, timestamp_value(self.occurrence_timestamp))
  end

  quota_critical_event.tag!("oub:critical.state") do quota_critical_event
    xml_data_item(quota_critical_event, self.critical_state)
  end

  quota_critical_event.tag!("oub:critical.state.change.date") do quota_critical_event
    xml_data_item(quota_critical_event, self.critical_state_change_date.try(:strftime, "%Y-%m-%d"))
  end
end
