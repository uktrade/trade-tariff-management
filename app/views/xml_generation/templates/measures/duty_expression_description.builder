xml.tag!("duty.expression.description") do |duty_expression_description|
  duty_expression_description.tag!("oub:duty.expression.id") do duty_expression_description
    xml_data_item(duty_expression_description, self.duty_expression_id)
  end

  duty_expression_description.tag!("oub:language.id") do duty_expression_description
    xml_data_item(duty_expression_description, self.language_id)
  end

  duty_expression_description.tag!("oub:description") do duty_expression_description
    xml_data_item(duty_expression_description, self.description)
  end
end
