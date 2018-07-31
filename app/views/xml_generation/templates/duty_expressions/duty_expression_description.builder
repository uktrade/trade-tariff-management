xml.tag!("oub:duty.expression.description") do |duty_expression_description|
  xml_data_item_v2(duty_expression_description, "duty.expression.id", self.duty_expression_id)
  xml_data_item_v2(duty_expression_description, "language.id", self.language_id)
  xml_data_item_v2(duty_expression_description, "description", self.description)
end
