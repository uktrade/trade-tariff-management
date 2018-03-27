xml.tag!("oub:export.refund.nomenclature") do |export_refund_nomenclature|
  export_refund_nomenclature.tag!("oub:export.refund.nomenclature.sid") do export_refund_nomenclature
    xml_data_item(export_refund_nomenclature, self.export_refund_nomenclature_sid)
  end

  export_refund_nomenclature.tag!("oub:goods.nomenclature.item.id") do export_refund_nomenclature
    xml_data_item(export_refund_nomenclature, self.goods_nomenclature_item_id)
  end

  export_refund_nomenclature.tag!("oub:additional.code.type") do export_refund_nomenclature
    xml_data_item(export_refund_nomenclature, self.additional_code_type)
  end

  export_refund_nomenclature.tag!("oub:export.refund.code") do export_refund_nomenclature
    xml_data_item(export_refund_nomenclature, self.export_refund_code)
  end

  export_refund_nomenclature.tag!("oub:productline.suffix") do export_refund_nomenclature
    xml_data_item(export_refund_nomenclature, self.productline_suffix)
  end

  export_refund_nomenclature.tag!("oub:goods.nomenclature.sid") do export_refund_nomenclature
    xml_data_item(export_refund_nomenclature, self.goods_nomenclature_sid)
  end

  export_refund_nomenclature.tag!("oub:validity.start.date") do export_refund_nomenclature
    xml_data_item(export_refund_nomenclature, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  export_refund_nomenclature.tag!("oub:validity.end.date") do export_refund_nomenclature
    xml_data_item(export_refund_nomenclature, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
