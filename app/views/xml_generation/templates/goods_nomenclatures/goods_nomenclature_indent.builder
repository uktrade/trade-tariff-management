xml.tag!("oub:goods.nomenclature.indents") do |goods_nomenclature_indent|
  goods_nomenclature_indent.tag!("oub:goods.nomenclature.indent.sid") do goods_nomenclature_indent
    xml_data_item(goods_nomenclature_indent, self.goods_nomenclature_indent_sid)
  end

  goods_nomenclature_indent.tag!("oub:goods.nomenclature.sid") do goods_nomenclature_indent
    xml_data_item(goods_nomenclature_indent, self.goods_nomenclature_sid)
  end

  goods_nomenclature_indent.tag!("oub:goods.nomenclature.item.id") do goods_nomenclature_indent
    xml_data_item(goods_nomenclature_indent, self.goods_nomenclature_item_id)
  end

  goods_nomenclature_indent.tag!("oub:number.indents") do goods_nomenclature_indent
    xml_data_item(goods_nomenclature_indent, self.number_indents)
  end

  goods_nomenclature_indent.tag!("oub:productline.suffix") do goods_nomenclature_indent
    xml_data_item(goods_nomenclature_indent, self.productline_suffix)
  end

  goods_nomenclature_indent.tag!("oub:validity.start.date") do goods_nomenclature_indent
    xml_data_item(goods_nomenclature_indent, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  goods_nomenclature_indent.tag!("oub:validity.end.date") do goods_nomenclature_indent
    xml_data_item(goods_nomenclature_indent, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
