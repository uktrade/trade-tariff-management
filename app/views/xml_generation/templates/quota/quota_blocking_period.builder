xml.tag!("oub:quota.blocking.period") do |quota_blocking_period|
  xml_data_item_v2(quota_blocking_period, "quota.blocking.period.sid", self.quota_blocking_period_sid)
  xml_data_item_v2(quota_blocking_period, "quota.definition.sid", self.quota_definition_sid)
  xml_data_item_v2(quota_blocking_period, "blocking.start.date", self.blocking_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(quota_blocking_period, "blocking.end.date", self.blocking_end_date.try(:strftime, "%Y-%m-%d"))
  xml_data_item_v2(quota_blocking_period, "blocking.period.type", self.blocking_period_type)
  xml_data_item_v2(quota_blocking_period, "description", self.description)
end
