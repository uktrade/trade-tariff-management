xml.tag!("oub:regulation.replacement") do |regulation_replacement|
  regulation_replacement.tag!("oub:replacing.regulation.role") do regulation_replacement
    xml_data_item(regulation_replacement, self.replacing_regulation_role)
  end

  regulation_replacement.tag!("oub:replacing.regulation.id") do regulation_replacement
    xml_data_item(regulation_replacement, self.replacing_regulation_id)
  end

  regulation_replacement.tag!("oub:replaced.regulation.role") do regulation_replacement
    xml_data_item(regulation_replacement, self.replaced_regulation_role)
  end

  regulation_replacement.tag!("oub:replaced.regulation.id") do regulation_replacement
    xml_data_item(regulation_replacement, self.replaced_regulation_id)
  end

  regulation_replacement.tag!("oub:measure.type.id") do regulation_replacement
    xml_data_item(regulation_replacement, self.measure_type_id)
  end

  regulation_replacement.tag!("oub:geographical.area.id") do regulation_replacement
    xml_data_item(regulation_replacement, self.geographical_area_id)
  end

  regulation_replacement.tag!("oub:chapter.heading") do regulation_replacement
    xml_data_item(regulation_replacement, self.chapter_heading)
  end
end
