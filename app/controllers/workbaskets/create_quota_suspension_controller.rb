
module Workbaskets
  class CreateQuotaSuspensionController < Workbaskets::BaseController
    skip_around_action :configure_time_machine, only: [:submitted_for_cross_check]

    expose(:sub_klass) { "CreateQuotaSuspension" }
    expose(:settings_type) { :create_quota_suspension }
    expose(:current_step) { "main" }

    respond_to :json

    def index
    end

    def new
      @create_quota_suspension_form = WorkbasketForms::CreateQuotaSuspensionForm.new
    end

    def create
    end

    def edit
    end

    def update
    end

    def search
    end
  end
end
