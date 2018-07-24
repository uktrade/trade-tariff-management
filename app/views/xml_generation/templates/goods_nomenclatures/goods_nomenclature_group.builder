xml.tag!("oub:goods.nomenclature.group") do |goods_nomenclature_group|
  xml_data_item_v2(goods_nomenclature_group, "goods.nomenclature.group.type", self.goods_nomenclature_group_type)
  xml_data_item_v2(goods_nomenclature_group, "goods.nomenclature.group.id", self.goods_nomenclature_group_id)
  xml_data_item_v2(goods_nomenclature_group, "nomenclature.group.facility.code", self.nomenclature_group_facility_code)
  xml_data_item_v2(goods_nomenclature_group, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(goods_nomenclature_group, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
