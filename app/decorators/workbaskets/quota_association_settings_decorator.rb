class Workbaskets::QuotaAssociationSettingsDecorator < ApplicationDecorator

  def description
    "#{parent_quota_order_id} and #{child_quota_order_id}"
  end

end
