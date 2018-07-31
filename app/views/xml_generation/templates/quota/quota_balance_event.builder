xml.tag!("oub:quota.balance.event") do |quota_balance_event|
  xml_data_item_v2(quota_balance_event, "quota.definition.sid", self.quota_definition_sid)
  xml_data_item_v2(quota_balance_event, "occurrence.timestamp", timestamp_value(self.occurrence_timestamp))
  xml_data_item_v2(quota_balance_event, "old.balance", self.old_balance)
  xml_data_item_v2(quota_balance_event, "new.balance", self.new_balance)
  xml_data_item_v2(quota_balance_event, "imported.amount", self.imported_amount)
  xml_data_item_v2(quota_balance_event, "last.import.date.in.allocation", self.last_import_date_in_allocation)
end
