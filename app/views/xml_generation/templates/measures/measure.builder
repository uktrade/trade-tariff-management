xml.tag!("oub:measure") do |measure|
  measure.tag!("oub:measure.sid") do measure
    xml_data_item(measure, self.measure_sid)
  end

  measure.tag!("oub:measure.type") do measure
    xml_data_item(measure, self.measure_type_id)
  end

  measure.tag!("oub:validity.start.date") do measure
    xml_data_item(measure, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  measure.tag!("oub:validity.end.date") do measure
    xml_data_item(measure, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end

  measure.tag!("oub:geographical.area") do measure
    xml_data_item(measure, self.geographical_area_id)
  end

  measure.tag!("oub:geographical.area.sid") do measure
    xml_data_item(measure, self.geographical_area_sid)
  end

  measure.tag!("oub:goods.nomenclature.item.id") do measure
    xml_data_item(measure, self.goods_nomenclature_item_id)
  end

  measure.tag!("oub:goods.nomenclature.sid") do measure
    xml_data_item(measure, self.goods_nomenclature_sid)
  end

  measure.tag!("oub:additional.code.sid") do measure
    xml_data_item(measure, self.additional_code_sid)
  end

  measure.tag!("oub:additional.code") do measure
    xml_data_item(measure, self.additional_code_id)
  end

  measure.tag!("oub:additional.code.type") do measure
    xml_data_item(measure, self.additional_code_type_id)
  end

  measure.tag!("oub:measure.generating.regulation.role") do measure
    xml_data_item(measure, self.measure_generating_regulation_role)
  end

  measure.tag!("oub:measure.generating.regulation.id") do measure
    xml_data_item(measure, self.measure_generating_regulation_id)
  end

  measure.tag!("oub:justification.regulation.role") do measure
    xml_data_item(measure, self.justification_regulation_role)
  end

  measure.tag!("oub:justification.regulation.id") do measure
    xml_data_item(measure, self.justification_regulation_id)
  end

  measure.tag!("oub:export.refund.nomenclature.sid") do measure
    xml_data_item(measure, self.export_refund_nomenclature_sid)
  end

  measure.tag!("oub:ordernumber") do measure
    xml_data_item(measure, self.ordernumber)
  end

  measure.tag!("oub:reduction.indicator") do measure
    xml_data_item(measure, self.reduction_indicator)
  end

  measure.tag!("oub:stopped.flag") do measure
    xml_data_item(measure, "0")
  end
end
