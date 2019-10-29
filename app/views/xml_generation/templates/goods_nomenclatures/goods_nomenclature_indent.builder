xml.tag!("oub:goods.nomenclature.indents") do |goods_nomenclature_indent|
  xml_data_item_v2(goods_nomenclature_indent, "goods.nomenclature.indent.sid", self.goods_nomenclature_indent_sid)
  xml_data_item_v2(goods_nomenclature_indent, "goods.nomenclature.sid", self.goods_nomenclature_sid)
  xml_data_item_v2(goods_nomenclature_indent, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(goods_nomenclature_indent, "number.indents", ("%02d" % self.number_indents))
  xml_data_item_v2(goods_nomenclature_indent, "goods.nomenclature.item.id", self.goods_nomenclature_item_id)
  xml_data_item_v2(goods_nomenclature_indent, "productline.suffix", self.productline_suffix)
end
