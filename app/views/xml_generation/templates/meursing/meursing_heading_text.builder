xml.tag!("oub:meursing.heading.text") do |meursing_heading_text|
  meursing_heading_text.tag!("oub:meursing.table.plan.id") do meursing_heading_text
    xml_data_item(meursing_heading_text, self.meursing_table_plan_id)
  end

  meursing_heading_text.tag!("oub:meursing.heading.number") do meursing_heading_text
    xml_data_item(meursing_heading_text, self.meursing_heading_number)
  end

  meursing_heading_text.tag!("oub:row.column.code") do meursing_heading_text
    xml_data_item(meursing_heading_text, self.row_column_code)
  end

  meursing_heading_text.tag!("oub:language.id") do meursing_heading_text
    xml_data_item(meursing_heading_text, self.language_id)
  end

  meursing_heading_text.tag!("oub:description") do meursing_heading_text
    xml_data_item(meursing_heading_text, self.description)
  end
end
