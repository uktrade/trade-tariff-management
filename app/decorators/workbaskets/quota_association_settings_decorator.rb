class Workbaskets::QuotaAssociationSettingsDecorator < ApplicationDecorator

  def description
    "#{parent_quota_order_id} and #{child_quota_order_id}"
  end

  def formatted_parent_quota_definition_period
    parent_definition = QuotaDefinition.find(quota_definition_sid: parent_quota_definition_period)
    "#{parent_definition.validity_start_date.to_s(:uk_Mmm)} to #{parent_definition.validity_end_date.to_s(:uk_Mmm)}"
  end

  def formatted_child_quota_definition_period
    child_definition = QuotaDefinition.find(quota_definition_sid: child_quota_definition_period)
    "#{child_definition.validity_start_date.to_s(:uk_Mmm)} to #{child_definition.validity_end_date.to_s(:uk_Mmm)}"
  end

end
