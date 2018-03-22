xml.tag!("oub:goods.nomenclature.group") do |goods_nomenclature_group|
  goods_nomenclature_group.tag!("oub:goods.nomenclature.group.type") do goods_nomenclature_group
    xml_data_item(goods_nomenclature_group, self.goods_nomenclature_group_type)
  end

  goods_nomenclature_group.tag!("oub:goods.nomenclature.group.id") do goods_nomenclature_group
    xml_data_item(goods_nomenclature_group, self.goods_nomenclature_group_id)
  end

  goods_nomenclature_group.tag!("oub:nomenclature.group.facility.code") do goods_nomenclature_group
    xml_data_item(goods_nomenclature_group, self.nomenclature_group_facility_code)
  end

  goods_nomenclature_group.tag!("oub:validity.start.date") do goods_nomenclature_group
    xml_data_item(goods_nomenclature_group, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  goods_nomenclature_group.tag!("oub:validity.end.date") do goods_nomenclature_group
    xml_data_item(goods_nomenclature_group, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
