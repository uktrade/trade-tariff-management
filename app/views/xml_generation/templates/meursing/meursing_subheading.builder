xml.tag!("oub:meursing.subheading") do |meursing_subheading|
  meursing_subheading.tag!("oub:meursing.table.plan.id") do meursing_subheading
    xml_data_item(meursing_subheading, self.meursing_table_plan_id)
  end

  meursing_subheading.tag!("oub:meursing.heading.number") do meursing_subheading
    xml_data_item(meursing_subheading, self.meursing_heading_number)
  end

  meursing_subheading.tag!("oub:row.column.code") do meursing_subheading
    xml_data_item(meursing_subheading, self.row_column_code)
  end

  meursing_subheading.tag!("oub:subheading.sequence.number") do meursing_subheading
    xml_data_item(meursing_subheading, self.subheading_sequence_number)
  end

  meursing_subheading.tag!("oub:description") do meursing_subheading
    xml_data_item(meursing_subheading, self.description)
  end

  meursing_subheading.tag!("oub:validity.start.date") do meursing_subheading
    xml_data_item(meursing_subheading, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  meursing_subheading.tag!("oub:validity.end.date") do meursing_subheading
    xml_data_item(meursing_subheading, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
