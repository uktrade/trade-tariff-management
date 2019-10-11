class QuotaAssociations::QuotaAssociationsController < ApplicationController

  def index
    @quota_associations = QuotaAssociation.where(quota_associations__status: 'published')
                            .join(QuotaDefinition.where{quota_definitions__validity_start_date >= 2.years.ago }, quota_definition_sid: :main_quota_definition_sid)
  end

end
