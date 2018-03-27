xml.tag!("oub:footnote.association.meursing.heading") do |footnote_association_meursing_heading|
  footnote_association_meursing_heading.tag!("oub:meursing.table.plan.id") do footnote_association_meursing_heading
    xml_data_item(footnote_association_meursing_heading, self.meursing_table_plan_id)
  end

  footnote_association_meursing_heading.tag!("oub:meursing.heading.number") do footnote_association_meursing_heading
    xml_data_item(footnote_association_meursing_heading, self.meursing_heading_number)
  end

  footnote_association_meursing_heading.tag!("oub:row.column.code") do footnote_association_meursing_heading
    xml_data_item(footnote_association_meursing_heading, self.row_column_code)
  end

  footnote_association_meursing_heading.tag!("oub:footnote.type") do footnote_association_meursing_heading
    xml_data_item(footnote_association_meursing_heading, self.footnote_type)
  end

  footnote_association_meursing_heading.tag!("oub:footnote.id") do footnote_association_meursing_heading
    xml_data_item(footnote_association_meursing_heading, self.footnote_id)
  end

  footnote_association_meursing_heading.tag!("oub:validity.start.date") do footnote_association_meursing_heading
    xml_data_item(footnote_association_meursing_heading, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  footnote_association_meursing_heading.tag!("oub:validity.end.date") do footnote_association_meursing_heading
    xml_data_item(footnote_association_meursing_heading, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
