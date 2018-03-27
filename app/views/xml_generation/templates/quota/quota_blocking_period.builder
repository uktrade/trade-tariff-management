xml.tag!("oub:quota.blocking.period") do |quota_blocking_period|
  quota_blocking_period.tag!("oub:quota.blocking.period.sid") do quota_blocking_period
    xml_data_item(quota_blocking_period, self.quota_blocking_period_sid)
  end

  quota_blocking_period.tag!("oub:quota.definition.sid") do quota_blocking_period
    xml_data_item(quota_blocking_period, self.quota_definition_sid)
  end

  quota_blocking_period.tag!("oub:blocking.period.type") do quota_blocking_period
    xml_data_item(quota_blocking_period, self.blocking_period_type)
  end

  quota_blocking_period.tag!("oub:description") do quota_blocking_period
    xml_data_item(quota_blocking_period, self.description)
  end

  quota_blocking_period.tag!("oub:blocking.start.date") do quota_blocking_period
    xml_data_item(quota_blocking_period, self.blocking_start_date.strftime("%Y-%m-%d"))
  end

  quota_blocking_period.tag!("oub:blocking.end.date") do quota_blocking_period
    xml_data_item(quota_blocking_period, self.blocking_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
