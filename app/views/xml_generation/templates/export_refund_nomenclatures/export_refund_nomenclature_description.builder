xml.tag!("oub:export.refund.nomenclature.description") do |export_refund_nomenclature_description|
  export_refund_nomenclature_description.tag!("oub:export.refund.nomenclature.description.period.sid") do export_refund_nomenclature_description
    xml_data_item(export_refund_nomenclature_description, self.export_refund_nomenclature_description_period_sid)
  end

  export_refund_nomenclature_description.tag!("oub:language.id") do export_refund_nomenclature_description
    xml_data_item(export_refund_nomenclature_description, self.language_id)
  end

  export_refund_nomenclature_description.tag!("oub:export.refund.nomenclature.sid") do export_refund_nomenclature_description
    xml_data_item(export_refund_nomenclature_description, self.export_refund_nomenclature_sid)
  end

  export_refund_nomenclature_description.tag!("oub:goods.nomenclature.item.id") do export_refund_nomenclature_description
    xml_data_item(export_refund_nomenclature_description, self.goods_nomenclature_item_id)
  end

  export_refund_nomenclature_description.tag!("oub:additional.code.type") do export_refund_nomenclature_description
    xml_data_item(export_refund_nomenclature_description, self.additional_code_type)
  end

  export_refund_nomenclature_description.tag!("oub:export.refund.code") do export_refund_nomenclature_description
    xml_data_item(export_refund_nomenclature_description, self.export_refund_code)
  end

  export_refund_nomenclature_description.tag!("oub:productline.suffix") do export_refund_nomenclature_description
    xml_data_item(export_refund_nomenclature_description, self.productline_suffix)
  end

  export_refund_nomenclature_description.tag!("oub:description") do export_refund_nomenclature_description
    xml_data_item(export_refund_nomenclature_description, self.description)
  end
end
