xml.tag!("oub:quota.order.number") do |quota_order_number|
  xml_data_item_v2(quota_order_number, "quota.order.number.sid", self.quota_order_number_sid)
  xml_data_item_v2(quota_order_number, "quota.order.number.id", self.quota_order_number_id)
  xml_data_item_v2(quota_order_number, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(quota_order_number, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
