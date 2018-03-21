xml.tag!("oub:export.refund.nomenclature.description.period") do |export_refund_nomenclature_description_period|
  export_refund_nomenclature_description_period.tag!("oub:export.refund.nomenclature.description.period.sid") do export_refund_nomenclature_description_period
    xml_data_item(export_refund_nomenclature_description_period, self.export_refund_nomenclature_description_period_sid)
  end

  export_refund_nomenclature_description_period.tag!("oub:export.refund.nomenclature.sid") do export_refund_nomenclature_description_period
    xml_data_item(export_refund_nomenclature_description_period, self.export_refund_nomenclature_sid)
  end

  export_refund_nomenclature_description_period.tag!("oub:goods.nomenclature.item.id") do export_refund_nomenclature_description_period
    xml_data_item(export_refund_nomenclature_description_period, self.goods_nomenclature_item_id)
  end

  export_refund_nomenclature_description_period.tag!("oub:additional.code.type") do export_refund_nomenclature_description_period
    xml_data_item(export_refund_nomenclature_description_period, self.additional_code_type)
  end

  export_refund_nomenclature_description_period.tag!("oub:export.refund.code") do export_refund_nomenclature_description_period
    xml_data_item(export_refund_nomenclature_description_period, self.export_refund_code)
  end

  export_refund_nomenclature_description_period.tag!("oub:productline.suffix") do export_refund_nomenclature_description_period
    xml_data_item(export_refund_nomenclature_description_period, self.productline_suffix)
  end

  export_refund_nomenclature_description_period.tag!("oub:validity.start.date") do export_refund_nomenclature_description_period
    xml_data_item(export_refund_nomenclature_description_period, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  export_refund_nomenclature_description_period.tag!("oub:validity.end.date") do export_refund_nomenclature_description_period
    xml_data_item(export_refund_nomenclature_description_period, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
