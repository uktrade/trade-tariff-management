xml.tag!("oub:goods.nomenclature") do |goods_nomenclature|
  goods_nomenclature.tag!("oub:goods.nomenclature.sid") do goods_nomenclature
    xml_data_item(goods_nomenclature, self.goods_nomenclature_sid)
  end

  goods_nomenclature.tag!("oub:goods.nomenclature.item.id") do goods_nomenclature
    xml_data_item(goods_nomenclature, self.goods_nomenclature_item_id)
  end

  goods_nomenclature.tag!("oub:producline.suffix") do goods_nomenclature
    xml_data_item(goods_nomenclature, self.producline_suffix)
  end

  goods_nomenclature.tag!("oub:statistical.indicator") do goods_nomenclature
    xml_data_item(goods_nomenclature, self.statistical_indicator)
  end

  goods_nomenclature.tag!("oub:validity.start.date") do goods_nomenclature
    xml_data_item(goods_nomenclature, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  goods_nomenclature.tag!("oub:validity.end.date") do goods_nomenclature
    xml_data_item(goods_nomenclature, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
