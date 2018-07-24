xml.tag!("oub:quota.critical.event") do |quota_critical_event|
  xml_data_item_v2(quota_critical_event, "quota.definition.sid", self.quota_definition_sid)
  xml_data_item_v2(quota_critical_event, "occurrence.timestamp", self.timestamp_value(self.occurrence_timestamp))
  xml_data_item_v2(quota_critical_event, "critical.state", self.critical_state)
  xml_data_item_v2(quota_critical_event, "critical.state.change.date", self.critical_state_change_date.try(:strftime, "%Y-%m-%d"))
end
