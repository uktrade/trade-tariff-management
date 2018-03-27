xml.tag!("oub:footnote.association.goods.nomenclature") do |footnote_association_goods_nomenclature|
  footnote_association_goods_nomenclature.tag!("oub:goods.nomenclature.sid") do footnote_association_goods_nomenclature
    xml_data_item(footnote_association_goods_nomenclature, self.goods_nomenclature_sid)
  end

  footnote_association_goods_nomenclature.tag!("oub:footnote.type") do footnote_association_goods_nomenclature
    xml_data_item(footnote_association_goods_nomenclature, self.footnote_type)
  end

  footnote_association_goods_nomenclature.tag!("oub:footnote.id") do footnote_association_goods_nomenclature
    xml_data_item(footnote_association_goods_nomenclature, self.footnote_id)
  end

  footnote_association_goods_nomenclature.tag!("oub:goods.nomenclature.item.id") do footnote_association_goods_nomenclature
    xml_data_item(footnote_association_goods_nomenclature, self.goods_nomenclature_item_id)
  end

  footnote_association_goods_nomenclature.tag!("oub:productline.suffix") do footnote_association_goods_nomenclature
    xml_data_item(footnote_association_goods_nomenclature, self.productline_suffix)
  end

  footnote_association_goods_nomenclature.tag!("oub:validity.start.date") do footnote_association_goods_nomenclature
    xml_data_item(footnote_association_goods_nomenclature, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  footnote_association_goods_nomenclature.tag!("oub:validity.end.date") do footnote_association_goods_nomenclature
    xml_data_item(footnote_association_goods_nomenclature, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
