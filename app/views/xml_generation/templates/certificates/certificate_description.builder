xml.tag!("oub:certificate.description") do |certificate_description|
  xml_data_item_v2(certificate_description, "certificate.description.period.sid", self.certificate_description_period_sid)
  xml_data_item_v2(certificate_description, "certificate.type.code", self.certificate_type_code)
  xml_data_item_v2(certificate_description, "certificate.code", self.certificate_code)
  xml_data_item_v2(certificate_description, "language.id", self.language_id)
  xml_data_item_v2(certificate_description, "description", self.description)
end
