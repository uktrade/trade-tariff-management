xml.tag!("oub:quota.order.number.origin.exclusions") do |quota_order_number_origin_exclusions|
  xml_data_item_v2(quota_order_number_origin_exclusions, "quota.order.number.origin.sid", self.quota_order_number_origin_sid)
  xml_data_item_v2(quota_order_number_origin_exclusions, "excluded.geographical.area.sid", self.excluded_geographical_area_sid)
end
