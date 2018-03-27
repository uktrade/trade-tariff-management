xml.tag!("oub:quota.balance.event") do |quota_balance_event|
  quota_balance_event.tag!("oub:quota.definition.sid") do quota_balance_event
    xml_data_item(quota_balance_event, self.quota_definition_sid)
  end

  quota_balance_event.tag!("oub:occurrence.timestamp") do quota_balance_event
    xml_data_item(quota_balance_event, timestamp_value(self.occurrence_timestamp))
  end

  quota_balance_event.tag!("oub:old.balance") do quota_balance_event
    xml_data_item(quota_balance_event, self.old_balance)
  end

  quota_balance_event.tag!("oub:new.balance") do quota_balance_event
    xml_data_item(quota_balance_event, self.new_balance)
  end

  quota_balance_event.tag!("oub:imported.amount") do quota_balance_event
    xml_data_item(quota_balance_event, self.imported_amount)
  end

  quota_balance_event.tag!("oub:last.import.date.in.allocation") do quota_balance_event
    xml_data_item(quota_balance_event, self.last_import_date_in_allocation)
  end
end
