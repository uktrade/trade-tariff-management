xml.tag!("oub:footnote.association.measure") do |footnote_association_measure|
  footnote_association_measure.tag!("oub:measure.sid") do footnote_association_measure
    xml_data_item(footnote_association_measure, self.measure_sid)
  end

  footnote_association_measure.tag!("oub:footnote.type.id") do footnote_association_measure
    xml_data_item(footnote_association_measure, self.footnote_type_id)
  end

  footnote_association_measure.tag!("oub:footnote.id") do footnote_association_measure
    xml_data_item(footnote_association_measure, self.footnote_id)
  end
end

