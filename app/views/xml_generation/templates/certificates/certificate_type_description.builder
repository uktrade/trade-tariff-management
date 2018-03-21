xml.tag!("oub:certificate.type.description") do |certificate_type_description|
  certificate_type_description.tag!("oub:certificate.type.code") do certificate_type_description
    xml_data_item(certificate_type_description, self.certificate_type_code)
  end

  certificate_type_description.tag!("oub:language.id") do certificate_type_description
    xml_data_item(certificate_type_description, self.language_id)
  end

  certificate_type_description.tag!("oub:description") do certificate_type_description
    xml_data_item(certificate_type_description, self.description)
  end
end
