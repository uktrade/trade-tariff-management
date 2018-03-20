xml.tag!("oub:footnote.association.additional.code") do |footnote_association_additional_code|
  footnote_association_additional_code.tag!("oub:additional.code.sid") do footnote_association_additional_code
    xml_data_item(footnote_association_additional_code, self.additional_code_sid)
  end

  footnote_association_additional_code.tag!("oub:footnote.type.id") do footnote_association_additional_code
    xml_data_item(footnote_association_additional_code, self.footnote_type_id)
  end

  footnote_association_additional_code.tag!("oub:footnote.id") do footnote_association_additional_code
    xml_data_item(footnote_association_additional_code, self.footnote_id)
  end

  footnote_association_additional_code.tag!("oub:additional.code.type.id") do footnote_association_additional_code
    xml_data_item(footnote_association_additional_code, self.additional_code_type_id)
  end

  footnote_association_additional_code.tag!("oub:additional.code") do footnote_association_additional_code
    xml_data_item(footnote_association_additional_code, self.additional_code)
  end

  footnote_association_additional_code.tag!("oub:validity.start.date") do footnote_association_additional_code
    xml_data_item(footnote_association_additional_code, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  footnote_association_additional_code.tag!("oub:validity.end.date") do footnote_association_additional_code
    xml_data_item(footnote_association_additional_code, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
