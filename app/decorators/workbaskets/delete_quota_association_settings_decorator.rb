class Workbaskets::DeleteQuotaAssociationSettingsDecorator < ApplicationDecorator

  def description
    "Parent ID '#{parent_definition.quota_order_number_id}' and Child ID '#{child_definition.quota_order_number_id}'"
  end

  def formatted_parent_quota_definition_period
    "#{parent_definition.validity_start_date.to_s(:uk_Mmm)} to #{parent_definition.validity_end_date.to_s(:uk_Mmm)}"
  end

  def formatted_child_quota_definition_period
    "#{child_definition.validity_start_date.to_s(:uk_Mmm)} to #{child_definition.validity_end_date.to_s(:uk_Mmm)}"
  end

  def parent_definition
    @parent_definition ||= QuotaDefinition.find(quota_definition_sid: main_quota_definition_sid)
  end

  def child_definition
    @child_definition ||= QuotaDefinition.find(quota_definition_sid: sub_quota_definition_sid)
  end

  def quota_association_relation_type
    quota_association.relation_type
  end

  def quota_association_coefficient
    quota_association.coefficient
  end

  def quota_association
    @child_association ||= QuotaAssociation.where(main_quota_definition_sid: main_quota_definition_sid,
                                                 sub_quota_definition_sid: sub_quota_definition_sid).order(Sequel.desc(:oid)).first
  end

end
