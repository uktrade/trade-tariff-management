xml.tag!("oub:quota.unblocking.event") do |quota_unblocking_event|
  xml_data_item_v2(quota_unblocking_event, "quota.definition.sid", self.quota_definition_sid)
  xml_data_item_v2(quota_unblocking_event, "occurrence.timestamp", self.timestamp_value(self.occurrence_timestamp))
  xml_data_item_v2(quota_unblocking_event, "unblocking.date", self.unblocking_date.try(:strftime, "%Y-%m-%d"))
end
