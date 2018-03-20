xml.tag!("oub:footnote.type") do |footnote_type|
  footnote_type.tag!("oub:footnote.type.id") do footnote_type
    xml_data_item(footnote_type, self.footnote_type_id)
  end

  footnote_type.tag!("oub:application.code") do footnote_type
    xml_data_item(footnote_type, self.application_code)
  end

  footnote_type.tag!("oub:validity.start.date") do footnote_type
    xml_data_item(footnote_type, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  footnote_type.tag!("oub:validity.end.date") do footnote_type
    xml_data_item(footnote_type, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
