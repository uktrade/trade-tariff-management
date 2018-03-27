xml.tag!("oub:monetary.unit") do |monetary_unit|
  monetary_unit.tag!("oub:monetary.unit.code") do monetary_unit
    xml_data_item(monetary_unit, self.monetary_unit_code)
  end

  monetary_unit.tag!("oub:validity.start.date") do monetary_unit
    xml_data_item(monetary_unit, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  monetary_unit.tag!("oub:validity.end.date") do monetary_unit
    xml_data_item(monetary_unit, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
