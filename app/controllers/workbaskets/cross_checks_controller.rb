module Workbaskets
  class CrossChecksController < Workbaskets::WorkflowBaseController

    before_action :require_cross_check_not_to_be_aready_started!, only: [:new]
    before_action :check_cross_check_permissions!, only: [:create, :show]

    expose(:checker) do
      ::WorkbasketInteractions::Workflow::CrossCheck.new(
        current_user, workbasket, params[:cross_check]
      )
    end

    expose(:check_completed_url) do
      cross_check_url(workbasket.id)
    end

    def new
      workbasket.assign_checker!(current_user)
    end

    private

      def require_cross_check_not_to_be_aready_started!
        unless workbasket.cross_check_process_can_be_started?
          redirect_url read_only_url
          return false
        end
      end

      def check_cross_check_permissions!
        unless workbasket.checker_id == current_user.id
          redirect_url read_only_url
          return false
        end
      end
  end
end
