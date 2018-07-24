xml.tag!("oub:measure.type") do |measure_type|
  xml_data_item_v2(measure_type, "measure.type.id", self.measure_type_id)
  xml_data_item_v2(measure_type, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(measure_type, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  xml_data_item_v2(measure_type, "trade.movement.code", self.trade_movement_code)
  xml_data_item_v2(measure_type, "priority.code", self.priority_code)
  xml_data_item_v2(measure_type, "measure.component.applicable.code", self.measure_component_applicable_code)
  xml_data_item_v2(measure_type, "origin.dest.code", self.origin_dest_code)
  xml_data_item_v2(measure_type, "order.number.capture.code", self.order_number_capture_code)
  xml_data_item_v2(measure_type, "measure.explosion.level", self.measure_explosion_level)
  xml_data_item_v2(measure_type, "measure.type.series.id", self.measure_type_series_id)
end
