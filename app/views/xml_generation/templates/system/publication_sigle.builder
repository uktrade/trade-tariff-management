xml.tag!("oub:publication.sigle") do |publication_sigle|
  xml_data_item_v2(publication_sigle, "code.type.id", self.code_type_id)
  xml_data_item_v2(publication_sigle, "code", self.code)
  xml_data_item_v2(publication_sigle, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(publication_sigle, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  xml_data_item_v2(publication_sigle, "publication.code", self.publication_code)
  xml_data_item_v2(publication_sigle, "publication.sigle", self.publication_sigle)
end
