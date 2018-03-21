xml.tag!("oub:certificate.description") do |certificate_description|
  certificate_description.tag!("oub:certificate.description.period.sid") do certificate_description
    xml_data_item(certificate_description, self.certificate_description_period_sid)
  end

  certificate_description.tag!("oub:certificate.type.code") do certificate_description
    xml_data_item(certificate_description, self.certificate_type_code)
  end

  certificate_description.tag!("oub:certificate.code") do certificate_description
    xml_data_item(certificate_description, self.certificate_code)
  end

  certificate_description.tag!("oub:language.id") do certificate_description
    xml_data_item(certificate_description, self.language_id)
  end

  certificate_description.tag!("oub:description") do certificate_description
    xml_data_item(certificate_description, self.description)
  end
end
