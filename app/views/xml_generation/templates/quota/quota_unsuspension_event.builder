xml.tag!("oub:quota.unsuspension.event") do |quota_unsuspension_event|
  xml_data_item_v2(quota_unsuspension_event, "quota.definition.sid", self.quota_definition_sid)
  xml_data_item_v2(quota_unsuspension_event, "occurrence.timestamp", self.timestamp_value(self.occurrence_timestamp))
  xml_data_item_v2(quota_unsuspension_event, "unsuspension.date", self.unsuspension_date.try(:strftime, "%Y-%m-%d"))
end
