xml.tag!("oub:certificate.type") do |certificate_type|
  certificate_type.tag!("oub:certificate.type.code") do certificate_type
    xml_data_item(certificate_type, self.certificate_type_code)
  end

  certificate_type.tag!("oub:validity.start.date") do certificate_type
    xml_data_item(certificate_type, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  certificate_type.tag!("oub:validity.end.date") do certificate_type
    xml_data_item(certificate_type, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
