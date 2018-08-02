xml.tag!("oub:certificate.description.period") do |certificate_description_period|
  xml_data_item_v2(certificate_description_period, "certificate.description.period.sid", self.certificate_description_period_sid)
  xml_data_item_v2(certificate_description_period, "certificate.type.code", self.certificate_type_code)
  xml_data_item_v2(certificate_description_period, "certificate.code", self.certificate_code)
  xml_data_item_v2(certificate_description_period, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
end
