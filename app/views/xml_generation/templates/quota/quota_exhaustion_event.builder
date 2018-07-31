xml.tag!("oub:quota.exhaustion.event") do |quota_exhaustion_event|
  xml_data_item_v2(quota_exhaustion_event, "quota.definition.sid", self.quota_definition_sid)
  xml_data_item_v2(quota_exhaustion_event, "occurrence.timestamp", self.timestamp_value(self.occurrence_timestamp))
  xml_data_item_v2(quota_exhaustion_event, "exhaustion.date", self.exhaustion_date.try(:strftime, "%Y-%m-%d"))
end
