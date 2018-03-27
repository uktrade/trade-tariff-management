xml.tag!("oub:quota.order.number.origin.exclusions") do |quota_order_number_origin_exclusions|
  quota_order_number_origin_exclusions.tag!("oub:quota.order.number.origin.sid") do quota_order_number_origin_exclusions
    xml_data_item(quota_order_number_origin_exclusions, self.quota_order_number_origin_sid)
  end

  quota_order_number_origin_exclusions.tag!("oub:excluded.geographical.area.sid") do quota_order_number_origin_exclusions
    xml_data_item(quota_order_number_origin_exclusions, self.excluded_geographical_area_sid)
  end
end
