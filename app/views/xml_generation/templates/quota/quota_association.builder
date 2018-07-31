xml.tag!("oub:quota.association") do |quota_association|
  xml_data_item_v2(quota_association, "main.quota.definition.sid", self.main_quota_definition_sid)
  xml_data_item_v2(quota_association, "sub.quota.definition.sid", self.sub_quota_definition_sid)
  xml_data_item_v2(quota_association, "relation.type", self.relation_type)
  xml_data_item_v2(quota_association, "coefficient", self.coefficient)
end
