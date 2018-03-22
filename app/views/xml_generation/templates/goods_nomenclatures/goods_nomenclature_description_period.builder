xml.tag!("oub:goods.nomenclature.description.period") do |goods_nomenclature_description_period|
  goods_nomenclature_description_period.tag!("oub:goods.nomenclature.description.period.sid") do goods_nomenclature_description_period
    xml_data_item(goods_nomenclature_description_period, self.goods_nomenclature_description_period_sid)
  end

  goods_nomenclature_description_period.tag!("oub:goods.nomenclature.sid") do goods_nomenclature_description_period
    xml_data_item(goods_nomenclature_description_period, self.goods_nomenclature_sid)
  end

  goods_nomenclature_description_period.tag!("oub:goods.nomenclature.item.id") do goods_nomenclature_description_period
    xml_data_item(goods_nomenclature_description_period, self.goods_nomenclature_item_id)
  end

  goods_nomenclature_description_period.tag!("oub:productline.suffix") do goods_nomenclature_description_period
    xml_data_item(goods_nomenclature_description_period, self.productline_suffix)
  end

  goods_nomenclature_description_period.tag!("oub:validity.start.date") do goods_nomenclature_description_period
    xml_data_item(goods_nomenclature_description_period, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  goods_nomenclature_description_period.tag!("oub:validity.end.date") do goods_nomenclature_description_period
    xml_data_item(goods_nomenclature_description_period, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
