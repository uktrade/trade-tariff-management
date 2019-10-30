class QuotaAssociations::QuotaAssociationsController < ApplicationController
  def index
    @quota_associations = QuotaAssociation.recent
  end
end
