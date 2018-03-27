xml.tag!("oub:quota.order.number.origin") do |quota_order_number_origin|
  quota_order_number_origin.tag!("oub:quota.order.number.origin.sid") do quota_order_number_origin
    xml_data_item(quota_order_number_origin, self.quota_order_number_origin_sid)
  end

  quota_order_number_origin.tag!("oub:quota.order.number.sid") do quota_order_number_origin
    xml_data_item(quota_order_number_origin, self.quota_order_number_sid)
  end

  quota_order_number_origin.tag!("oub:geographical.area.id") do quota_order_number_origin
    xml_data_item(quota_order_number_origin, self.geographical_area_id)
  end

  quota_order_number_origin.tag!("oub:geographical.area.sid") do quota_order_number_origin
    xml_data_item(quota_order_number_origin, self.geographical_area_sid)
  end

  quota_order_number_origin.tag!("oub:validity.start.date") do quota_order_number_origin
    xml_data_item(quota_order_number_origin, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  quota_order_number_origin.tag!("oub:validity.end.date") do quota_order_number_origin
    xml_data_item(quota_order_number_origin, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
