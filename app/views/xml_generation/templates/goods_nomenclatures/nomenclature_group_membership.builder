xml.tag!("oub:nomenclature.group.membership") do |nomenclature_group_membership|
  xml_data_item_v2(nomenclature_group_membership, "goods.nomenclature.sid", self.goods_nomenclature_sid)
  xml_data_item_v2(nomenclature_group_membership, "goods.nomenclature.group.type", self.goods_nomenclature_group_type)
  xml_data_item_v2(nomenclature_group_membership, "goods.nomenclature.group.id", self.goods_nomenclature_group_id)
  xml_data_item_v2(nomenclature_group_membership, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(nomenclature_group_membership, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  xml_data_item_v2(nomenclature_group_membership, "goods.nomenclature.item.id", self.goods_nomenclature_item_id)
  xml_data_item_v2(nomenclature_group_membership, "productline.suffix", self.productline_suffix)
end
