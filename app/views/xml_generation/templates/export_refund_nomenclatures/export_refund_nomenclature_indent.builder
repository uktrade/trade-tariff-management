xml.tag!("oub:export.refund.nomenclature.indents") do |export_refund_nomenclature_indents|
  export_refund_nomenclature_indents.tag!("oub:export.refund.nomenclature.indents.sid") do export_refund_nomenclature_indents
    xml_data_item(export_refund_nomenclature_indents, self.export_refund_nomenclature_indents_sid)
  end

  export_refund_nomenclature_indents.tag!("oub:export.refund.nomenclature.sid") do export_refund_nomenclature_indents
    xml_data_item(export_refund_nomenclature_indents, self.export_refund_nomenclature_sid)
  end

  export_refund_nomenclature_indents.tag!("oub:number.export.refund.nomenclature.indents") do export_refund_nomenclature_indents
    xml_data_item(export_refund_nomenclature_indents, self.number_export_refund_nomenclature_indents)
  end

  export_refund_nomenclature_indents.tag!("oub:goods.nomenclature.item.id") do export_refund_nomenclature_indents
    xml_data_item(export_refund_nomenclature_indents, self.goods_nomenclature_item_id)
  end

  export_refund_nomenclature_indents.tag!("oub:additional.code.type") do export_refund_nomenclature_indents
    xml_data_item(export_refund_nomenclature_indents, self.additional_code_type)
  end

  export_refund_nomenclature_indents.tag!("oub:export.refund.code") do export_refund_nomenclature_indents
    xml_data_item(export_refund_nomenclature_indents, self.export_refund_code)
  end

  export_refund_nomenclature_indents.tag!("oub:productline.suffix") do export_refund_nomenclature_indents
    xml_data_item(export_refund_nomenclature_indents, self.productline_suffix)
  end

  export_refund_nomenclature_indents.tag!("oub:validity.start.date") do export_refund_nomenclature_indents
    xml_data_item(export_refund_nomenclature_indents, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  export_refund_nomenclature_indents.tag!("oub:validity.end.date") do export_refund_nomenclature_indents
    xml_data_item(export_refund_nomenclature_indents, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
