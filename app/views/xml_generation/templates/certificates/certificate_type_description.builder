xml.tag!("oub:certificate.type.description") do |certificate_type_description|
  xml_data_item_v2(certificate_type_description, "certificate.type.code", self.certificate_type_code)
  xml_data_item_v2(certificate_type_description, "language.id", self.language_id)
  xml_data_item_v2(certificate_type_description, "description", self.description)
end
