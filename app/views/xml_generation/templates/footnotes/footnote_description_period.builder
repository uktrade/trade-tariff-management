xml.tag!("oub:footnote.description.period") do |footnote_description_period|
  footnote_description_period.tag!("oub:footnote.description.period.sid") do footnote_description_period
    xml_data_item(footnote_description_period, self.footnote_description_period_sid)
  end

  footnote_description_period.tag!("oub:footnote.type.id") do footnote_description_period
    xml_data_item(footnote_description_period, self.footnote_type_id)
  end

  footnote_description_period.tag!("oub:footnote.id") do footnote_description_period
    xml_data_item(footnote_description_period, self.footnote_id)
  end

  footnote_description_period.tag!("oub:validity.start.date") do footnote_description_period
    xml_data_item(footnote_description_period, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  footnote_description_period.tag!("oub:validity.end.date") do footnote_description_period
    xml_data_item(footnote_description_period, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
