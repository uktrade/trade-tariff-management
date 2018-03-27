xml.tag!("oub:nomenclature.group.membership") do |nomenclature_group_membership|
  nomenclature_group_membership.tag!("oub:goods.nomenclature.sid") do nomenclature_group_membership
    xml_data_item(nomenclature_group_membership, self.goods_nomenclature_sid)
  end

  nomenclature_group_membership.tag!("oub:goods.nomenclature.group.type") do nomenclature_group_membership
    xml_data_item(nomenclature_group_membership, self.goods_nomenclature_group_type)
  end

  nomenclature_group_membership.tag!("oub:goods.nomenclature.group.id") do nomenclature_group_membership
    xml_data_item(nomenclature_group_membership, self.goods_nomenclature_group_id)
  end

  nomenclature_group_membership.tag!("oub:goods.nomenclature.item.id") do nomenclature_group_membership
    xml_data_item(nomenclature_group_membership, self.goods_nomenclature_item_id)
  end

  nomenclature_group_membership.tag!("oub:productline.suffix") do nomenclature_group_membership
    xml_data_item(nomenclature_group_membership, self.productline_suffix)
  end

  nomenclature_group_membership.tag!("oub:validity.start.date") do nomenclature_group_membership
    xml_data_item(nomenclature_group_membership, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  nomenclature_group_membership.tag!("oub:validity.end.date") do nomenclature_group_membership
    xml_data_item(nomenclature_group_membership, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
