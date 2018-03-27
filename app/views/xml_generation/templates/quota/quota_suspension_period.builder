xml.tag!("oub:quota.suspension.period") do |quota_suspension_period|
  quota_suspension_period.tag!("oub:quota.suspension.period.sid") do quota_suspension_period
    xml_data_item(quota_suspension_period, self.quota_suspension_period_sid)
  end

  quota_suspension_period.tag!("oub:quota.definition.sid") do quota_suspension_period
    xml_data_item(quota_suspension_period, self.quota_definition_sid)
  end

  quota_suspension_period.tag!("oub:description") do quota_suspension_period
    xml_data_item(quota_suspension_period, self.description)
  end

  quota_suspension_period.tag!("oub:suspension.start.date") do quota_suspension_period
    xml_data_item(quota_suspension_period, self.suspension_start_date.try(:strftime, "%Y-%m-%d"))
  end

  quota_suspension_period.tag!("oub:suspension.end.date") do quota_suspension_period
    xml_data_item(quota_suspension_period, self.suspension_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
