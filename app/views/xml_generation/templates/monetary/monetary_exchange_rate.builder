xml.tag!("oub:monetary.exchange.rate") do |monetary_exchange_rate|
  monetary_exchange_rate.tag!("oub:monetary.exchange.period.sid") do monetary_exchange_rate
    xml_data_item(monetary_exchange_rate, self.monetary_exchange_period_sid)
  end

  monetary_exchange_rate.tag!("oub:child.monetary.unit.code") do monetary_exchange_rate
    xml_data_item(monetary_exchange_rate, self.child_monetary_unit_code)
  end

  monetary_exchange_rate.tag!("oub:exchange.rate") do monetary_exchange_rate
    xml_data_item(monetary_exchange_rate, self.exchange_rate)
  end
end
