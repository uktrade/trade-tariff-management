xml.tag!("oub:footnote.association.ern") do |footnote_association_ern|
  footnote_association_ern.tag!("oub:export.refund.nomenclature.sid") do footnote_association_ern
    xml_data_item(footnote_association_ern, self.export_refund_nomenclature_sid)
  end

  footnote_association_ern.tag!("oub:footnote.type") do footnote_association_ern
    xml_data_item(footnote_association_ern, self.footnote_type)
  end

  footnote_association_ern.tag!("oub:footnote.id") do footnote_association_ern
    xml_data_item(footnote_association_ern, self.footnote_id)
  end

  footnote_association_ern.tag!("oub:goods.nomenclature.item.id") do footnote_association_ern
    xml_data_item(footnote_association_ern, self.goods_nomenclature_item_id)
  end

  footnote_association_ern.tag!("oub:additional.code.type") do footnote_association_ern
    xml_data_item(footnote_association_ern, self.additional_code_type)
  end

  footnote_association_ern.tag!("oub:export.refund.code") do footnote_association_ern
    xml_data_item(footnote_association_ern, self.export_refund_code)
  end

  footnote_association_ern.tag!("oub:productline.suffix") do footnote_association_ern
    xml_data_item(footnote_association_ern, self.productline_suffix)
  end

  footnote_association_ern.tag!("oub:validity.start.date") do footnote_association_ern
    xml_data_item(footnote_association_ern, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  footnote_association_ern.tag!("oub:validity.end.date") do footnote_association_ern
    xml_data_item(footnote_association_ern, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
