xml.tag!("oub:footnote.association.measure") do |footnote_association_measure|
  xml_data_item_v2(footnote_association_measure, "measure.sid", self.measure_sid)
  xml_data_item_v2(footnote_association_measure, "footnote.type.id", self.footnote_type_id)
  xml_data_item_v2(footnote_association_measure, "footnote.id", self.footnote_id)
end
