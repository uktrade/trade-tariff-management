xml.tag!("oub:meursing.additional.code") do |meursing_additional_code|
  xml_data_item_v2(meursing_additional_code, "meursing.additional.code.sid", self.meursing_additional_code_sid)
  xml_data_item_v2(meursing_additional_code, "validity.end.date", self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  xml_data_item_v2(meursing_additional_code, "additional.code", self.additional_code)
  xml_data_item_v2(meursing_additional_code, "validity.start.date", self.validity_start_date.strftime("%Y-%m-%d"))
end
