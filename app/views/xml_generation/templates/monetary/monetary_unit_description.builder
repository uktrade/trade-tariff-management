xml.tag!("oub:monetary.unit.description") do |monetary_unit_description|
  monetary_unit_description.tag!("oub:monetary.unit.code") do monetary_unit_description
    xml_data_item(monetary_unit_description, self.monetary_unit_code)
  end

  monetary_unit_description.tag!("oub:language.id") do monetary_unit_description
    xml_data_item(monetary_unit_description, self.language_id)
  end

  monetary_unit_description.tag!("oub:description") do monetary_unit_description
    xml_data_item(monetary_unit_description, self.description)
  end
end
