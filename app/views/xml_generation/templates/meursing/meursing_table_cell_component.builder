xml.tag!("oub:meursing.table.cell.component") do |meursing_table_cell_component|
  meursing_table_cell_component.tag!("oub:meursing.additional.code.sid") do meursing_table_cell_component
    xml_data_item(meursing_table_cell_component, self.meursing_additional_code_sid)
  end

  meursing_table_cell_component.tag!("oub:meursing.table.plan.id") do meursing_table_cell_component
    xml_data_item(meursing_table_cell_component, self.meursing_table_plan_id)
  end

  meursing_table_cell_component.tag!("oub:heading.number") do meursing_table_cell_component
    xml_data_item(meursing_table_cell_component, self.heading_number)
  end

  meursing_table_cell_component.tag!("oub:row.column.code") do meursing_table_cell_component
    xml_data_item(meursing_table_cell_component, self.row_column_code)
  end

  meursing_table_cell_component.tag!("oub:subheading.sequence.number") do meursing_table_cell_component
    xml_data_item(meursing_table_cell_component, self.subheading_sequence_number)
  end

  meursing_table_cell_component.tag!("oub:additional.code") do meursing_table_cell_component
    xml_data_item(meursing_table_cell_component, self.additional_code)
  end

  meursing_table_cell_component.tag!("oub:validity.start.date") do meursing_table_cell_component
    xml_data_item(meursing_table_cell_component, self.validity_start_date.strftime("%Y-%m-%d"))
  end

  meursing_table_cell_component.tag!("oub:validity.end.date") do meursing_table_cell_component
    xml_data_item(meursing_table_cell_component, self.validity_end_date.try(:strftime, "%Y-%m-%d"))
  end
end
