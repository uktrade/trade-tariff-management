xml.tag!("oub:quota.order.number") do |quota_order_number|
  quota_order_number.tag!("oub:quota.order.number.sid") do quota_order_number
    xml_data_item(quota_order_number, self.quota_order_number_sid)
  end

  quota_order_number.tag!("oub:quota.order.number.id") do quota_order_number
    xml_data_item(quota_order_number, self.quota_order_number_id)
  end

  quota_order_number.tag!("oub:validity.start.date") do quota_order_number
    xml_data_item(quota_order_number, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  quota_order_number.tag!("oub:validity.end.date") do quota_order_number
    xml_data_item(quota_order_number, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
