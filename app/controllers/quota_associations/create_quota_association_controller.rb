
module Workbaskets
  class QuotaAssociations::CreateQuotaAssociationController < Workbaskets::BaseController

    respond_to :json

    def index

    end

    def new

    end

    def search
      if(params.has_key?(:parent_quota) && params.has_key?(:child_quota))
        redirect_to new_create_quota_association_url
      end
    end

  end
end
