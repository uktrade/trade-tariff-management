xml.tag!("oub:quota.definition") do |quota_definition|
  quota_definition.tag!("oub:quota.definition.sid") do quota_definition
    xml_data_item(quota_definition, self.quota_definition_sid)
  end

  quota_definition.tag!("oub:quota.order.number.id") do quota_definition
    xml_data_item(quota_definition, self.quota_order_number_id)
  end

  quota_definition.tag!("oub:quota.order.number.sid") do quota_definition
    xml_data_item(quota_definition, self.quota_order_number_sid)
  end

  quota_definition.tag!("oub:volume") do quota_definition
    xml_data_item(quota_definition, self.volume)
  end

  quota_definition.tag!("oub:initial.volume") do quota_definition
    xml_data_item(quota_definition, self.initial_volume)
  end

  quota_definition.tag!("oub:monetary.unit.code") do quota_definition
    xml_data_item(quota_definition, self.monetary_unit_code)
  end

  quota_definition.tag!("oub:measurement.unit.code") do quota_definition
    xml_data_item(quota_definition, self.measurement_unit_code)
  end

  quota_definition.tag!("oub:measurement.unit.qualifier.code") do quota_definition
    xml_data_item(quota_definition, self.measurement_unit_qualifier_code)
  end

  quota_definition.tag!("oub:maximum.precision") do quota_definition
    xml_data_item(quota_definition, self.maximum_precision)
  end

  quota_definition.tag!("oub:critical.state") do quota_definition
    xml_data_item(quota_definition, self.critical_state)
  end

  quota_definition.tag!("oub:critical.threshold") do quota_definition
    xml_data_item(quota_definition, self.critical_threshold)
  end

  quota_definition.tag!("oub:description") do quota_definition
    xml_data_item(quota_definition, self.description)
  end

  quota_definition.tag!("oub:validity.start.date") do quota_definition
    xml_data_item(quota_definition, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  quota_definition.tag!("oub:validity.end.date") do quota_definition
    xml_data_item(quota_definition, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
