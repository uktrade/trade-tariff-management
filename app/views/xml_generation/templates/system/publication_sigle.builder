xml.tag!("oub:publication.sigle") do |publication_sigle|
  publication_sigle.tag!("oub:code.type.id") do publication_sigle
    xml_data_item(publication_sigle, self.code_type_id)
  end

  publication_sigle.tag!("oub:code") do publication_sigle
    xml_data_item(publication_sigle, self.code)
  end

  publication_sigle.tag!("oub:publication.code") do publication_sigle
    xml_data_item(publication_sigle, self.publication_code)
  end

  publication_sigle.tag!("oub:publication.sigle") do publication_sigle
    xml_data_item(publication_sigle, self.publication_sigle)
  end

  publication_sigle.tag!("oub:validity.start.date") do publication_sigle
    xml_data_item(publication_sigle, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  publication_sigle.tag!("oub:validity.end.date") do publication_sigle
    xml_data_item(publication_sigle, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
