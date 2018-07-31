xml.tag!("oub:quota.suspension.period") do |quota_suspension_period|
  xml_data_item_v2(quota_suspension_period, "quota.suspension.period.sid", self.quota_suspension_period_sid)
  xml_data_item_v2(quota_suspension_period, "quota.definition.sid", self.quota_definition_sid)
  xml_data_item_v2(quota_suspension_period, "description", self.description)
  xml_data_item_v2(quota_suspension_period, "suspension.start.date", self.suspension_start_date.try(:strftime, "%Y-%m-%d"))
  xml_data_item_v2(quota_suspension_period, "suspension.end.date", self.suspension_end_date.try(:strftime, "%Y-%m-%d"))
end
