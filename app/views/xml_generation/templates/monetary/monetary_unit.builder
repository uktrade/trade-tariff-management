xml.tag!("oub:monetary.unit") do |monetary_unit|
  xml_data_item_v2(monetary_unit, "monetary.unit.code", self.monetary_unit_code)
  xml_data_item_v2(monetary_unit, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(monetary_unit, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d")
end
