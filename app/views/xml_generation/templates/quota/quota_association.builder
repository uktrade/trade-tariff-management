xml.tag!("oub:quota.association") do |quota_association|
  xml_data_item_v2(quota_association, "main.quota.definition.sid", self.main_quota_definition_sid)
  quota_association.tag!("oub:") do quota_association
    xml_data_item(quota_association, self.)
  end

  xml_data_item_v2(quota_association, "sub.quota.definition.sid", self.sub_quota_definition_sid)
  quota_association.tag!("oub:") do quota_association
    xml_data_item(quota_association, self.)
  end

  xml_data_item_v2(quota_association, "relation.type", self.relation_type)
  quota_association.tag!("oub:") do quota_association
    xml_data_item(quota_association, self.)
  end

  xml_data_item_v2(quota_association, ""coefficient, self.coefficient)
  quota_association.tag!("oub:") do quota_association
    xml_data_item(quota_association, self.)
  end
end
