xml.tag!("oub:quota.reopening.event") do |quota_reopening_event|
  quota_reopening_event.tag!("oub:quota.definition.sid") do quota_reopening_event
    xml_data_item(quota_reopening_event, self.quota_definition_sid)
  end

  quota_reopening_event.tag!("oub:occurrence.timestamp") do quota_reopening_event
    xml_data_item(quota_reopening_event, timestamp_value(self.occurrence_timestamp))
  end

  quota_reopening_event.tag!("oub:reopening.date") do quota_reopening_event
    xml_data_item(quota_reopening_event, self.reopening_date.try(:strftime, "%Y-%m-%d"))
  end
end
