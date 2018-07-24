xml.tag!("oub:quota.reopening.event") do |quota_reopening_event|
  xml_data_item_v2(quota_reopening_event, "quota.definition.sid", self.quota_definition_sid)
  xml_data_item_v2(quota_reopening_event, "occurrence.timestamp", self.timestamp_value(self.occurrence_timestamp))
  xml_data_item_v2(quota_reopening_event, "reopening.date", self.reopening_date.try(:strftime, "%Y-%m-%d"))
end
