xml.tag!("oub:monetary.exchange.period") do |monetary_exchange_period|
  monetary_exchange_period.tag!("oub:monetary.exchange.period.sid") do monetary_exchange_period
    xml_data_item(monetary_exchange_period, self.monetary_exchange_period_sid)
  end

  monetary_exchange_period.tag!("oub:parent.monetary.unit.code") do monetary_exchange_period
    xml_data_item(monetary_exchange_period, self.parent_monetary_unit_code)
  end

  monetary_exchange_period.tag!("oub:validity.start.date") do monetary_exchange_period
    xml_data_item(monetary_exchange_period, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  monetary_exchange_period.tag!("oub:validity.end.date") do monetary_exchange_period
    xml_data_item(monetary_exchange_period, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
