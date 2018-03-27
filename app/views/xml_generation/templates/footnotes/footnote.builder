xml.tag!("oub:footnote") do |footnote|
  footnote.tag!("oub:footnote.type.id") do footnote
    xml_data_item(footnote, self.footnote_type_id)
  end

  footnote.tag!("oub:footnote.id") do footnote
    xml_data_item(footnote, self.footnote_id)
  end

  footnote.tag!("oub:validity.start.date") do footnote
    xml_data_item(footnote, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  footnote.tag!("oub:validity.end.date") do footnote
    xml_data_item(footnote, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
