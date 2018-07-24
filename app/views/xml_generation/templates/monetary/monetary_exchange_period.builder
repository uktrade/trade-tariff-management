xml.tag!("oub:monetary.exchange.period") do |monetary_exchange_period|
  xml_data_item_v2(monetary_exchange_period, "monetary.exchange.period.sid", self.monetary_exchange_period_sid)
  xml_data_item_v2(monetary_exchange_period, "parent.monetary.unit.code", self.parent_monetary_unit_code)
  xml_data_item_v2(monetary_exchange_period, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(monetary_exchange_period, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
