xml.tag!("oub:quota.order.number.origin") do |quota_order_number_origin|
  xml_data_item_v2(quota_order_number_origin, "quota.order.number.origin.sid", self.quota_order_number_origin_sid)
  xml_data_item_v2(quota_order_number_origin, "quota.order.number.sid", self.quota_order_number_sid)
  xml_data_item_v2(quota_order_number_origin, "geographical.area.id", self.geographical_area_id)
  xml_data_item_v2(quota_order_number_origin, "geographical.area.sid", self.geographical_area_sid)
  xml_data_item_v2(quota_order_number_origin, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(quota_order_number_origin, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
