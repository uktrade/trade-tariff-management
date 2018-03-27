xml.tag!("oub:quota.association") do |quota_association|
  quota_association.tag!("oub:main.quota.definition.sid") do quota_association
    xml_data_item(quota_association, self.main_quota_definition_sid)
  end

  quota_association.tag!("oub:sub.quota.definition.sid") do quota_association
    xml_data_item(quota_association, self.sub_quota_definition_sid)
  end

  quota_association.tag!("oub:relation.type") do quota_association
    xml_data_item(quota_association, self.relation_type)
  end

  quota_association.tag!("oub:coefficient") do quota_association
    xml_data_item(quota_association, self.coefficient)
  end
end
