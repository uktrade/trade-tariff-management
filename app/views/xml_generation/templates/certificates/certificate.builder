xml.tag!("oub:certificate") do |certificate|
  certificate.tag!("oub:certificate.type.code") do certificate
    xml_data_item(certificate, self.certificate_type_code)
  end

  certificate.tag!("oub:certificate.code") do certificate
    xml_data_item(certificate, self.certificate_code)
  end

  certificate.tag!("oub:national.abbrev") do certificate
    xml_data_item(certificate, self.national_abbrev)
  end

  certificate.tag!("oub:validity.start.date") do certificate
    xml_data_item(certificate, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  certificate.tag!("oub:validity.end.date") do certificate
    xml_data_item(certificate, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
