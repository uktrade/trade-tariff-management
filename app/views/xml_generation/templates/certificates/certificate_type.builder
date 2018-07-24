xml.tag!("oub:certificate.type") do |certificate_type|
  xml_data_item_v2(certificate_type, "certificate.type.code", self.certificate_type_code)
  xml_data_item_v2(certificate_type, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(certificate_type, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
