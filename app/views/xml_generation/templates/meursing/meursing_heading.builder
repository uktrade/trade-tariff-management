xml.tag!("oub:meursing.heading") do |meursing_heading|
  meursing_heading.tag!("oub:meursing.table.plan.id") do meursing_heading
    xml_data_item(meursing_heading, self.meursing_table_plan_id)
  end

  meursing_heading.tag!("oub:meursing.heading.number") do meursing_heading
    xml_data_item(meursing_heading, self.meursing_heading_number)
  end

  meursing_heading.tag!("oub:row.column.code") do meursing_heading
    xml_data_item(meursing_heading, self.row_column_code)
  end

  meursing_heading.tag!("oub:validity.start.date") do meursing_heading
    xml_data_item(meursing_heading, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  meursing_heading.tag!("oub:validity.end.date") do meursing_heading
    xml_data_item(meursing_heading, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
