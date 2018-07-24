xml.tag!("oub:monetary.exchange.rate") do |monetary_exchange_rate|
  xml_data_item_v2(monetary_exchange_rate, "monetary.exchange.period.sid", self.monetary_exchange_period_sid)
  xml_data_item_v2(monetary_exchange_rate, "child.monetary.unit.code", self.child_monetary_unit_code)
  xml_data_item_v2(monetary_exchange_rate, "exchange.rate", self.exchange_rate)
end
