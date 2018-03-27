xml.tag!("oub:quota.unsuspension.event") do |quota_unsuspension_event|
  quota_unsuspension_event.tag!("oub:quota.definition.sid") do quota_unsuspension_event
    xml_data_item(quota_unsuspension_event, self.quota_definition_sid)
  end

  quota_unsuspension_event.tag!("oub:occurrence.timestamp") do quota_unsuspension_event
    xml_data_item(quota_unsuspension_event, timestamp_value(self.occurrence_timestamp))
  end

  quota_unsuspension_event.tag!("oub:unsuspension.date") do quota_unsuspension_event
    xml_data_item(quota_unsuspension_event, self.unsuspension_date.try(:strftime, "%Y-%m-%d"))
  end
end
