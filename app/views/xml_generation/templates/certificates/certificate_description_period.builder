xml.tag!("oub:certificate.description.period") do |certificate_description_period|
  certificate_description_period.tag!("oub:certificate.description.period.sid") do certificate_description_period
    xml_data_item(certificate_description_period, self.certificate_description_period_sid)
  end

  certificate_description_period.tag!("oub:certificate.type.code") do certificate_description_period
    xml_data_item(certificate_description_period, self.certificate_type_code)
  end

  certificate_description_period.tag!("oub:certificate.code") do certificate_description_period
    xml_data_item(certificate_description_period, self.certificate_code)
  end

  certificate_description_period.tag!("oub:validity.start.date") do certificate_description_period
    xml_data_item(certificate_description_period, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  certificate_description_period.tag!("oub:validity.end.date") do certificate_description_period
    xml_data_item(certificate_description_period, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
