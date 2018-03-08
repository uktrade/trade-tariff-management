xml.tag!("oub:measure.type") do |measure_type|
  measure_type.tag!("oub:measure.type.id") do measure_type
    xml_data_item(measure_type, self.measure_type_id)
  end

  measure_type.tag!("oub:validity.start.date") do measure_type
    xml_data_item(measure_type, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  measure_type.tag!("oub:validity.end.date") do measure_type
    xml_data_item(measure_type, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end

  measure_type.tag!("oub:trade.movement.code") do measure_type
    xml_data_item(measure_type, self.trade_movement_code)
  end

  measure_type.tag!("oub:priority.code") do measure_type
    xml_data_item(measure_type, self.priority_code)
  end

  measure_type.tag!("oub:measure.component.applicable.code") do measure_type
    xml_data_item(measure_type, self.measure_component_applicable_code)
  end

  measure_type.tag!("oub:origin.dest.code") do measure_type
    xml_data_item(measure_type, self.origin_dest_code)
  end

  measure_type.tag!("oub:order.number.capture.code") do measure_type
    xml_data_item(measure_type, self.order_number_capture_code)
  end

  measure_type.tag!("oub:measure.explosion.level") do measure_type
    xml_data_item(measure_type, self.measure_explosion_level)
  end

  measure_type.tag!("oub:measure.type.series.id") do measure_type
    xml_data_item(measure_type, self.measure_type_series_id)
  end
end
