xml.tag!("oub:certificate") do |certificate|
  xml_data_item_v2(certificate, "certificate.type.code", self.certificate_type_code)
  xml_data_item_v2(certificate, "certificate.code", self.certificate_code)
  xml_data_item_v2(certificate, "national.abbrev", self.national_abbrev)
  xml_data_item_v2(certificate, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
  xml_data_item_v2(certificate, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
end
