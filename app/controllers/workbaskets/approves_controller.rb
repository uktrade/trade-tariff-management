module Workbaskets
  class ApprovesController < Workbaskets::WorkflowBaseController

    before_action :require_to_be_approver!
    before_action :require_cross_check_not_to_be_aready_started!, only: [:new]
    before_action :check_cross_check_permissions!, only: [:create, :show]

    expose(:form) do
      WorkbasketForms::ApproveForm.new
    end

    expose(:approver) do
      ::WorkbasketInteractions::Workflow::Approve.new(
        current_user, workbasket, params[:approve]
      )
    end

    expose(:next_approve) do
      current_user.next_workbasket_to_approve
    end

    def new
      workbasket.assign_approver!(current_user)
    end

    def create
      if approver.valid?
        approver.persist!

        render json: { redirect_url: approve_url(workbasket.id) },
                       status: :ok
      else
        render json: {
          errors: approver.errors,
        }, status: :unprocessable_entity
      end
    end

    private

      def require_to_be_approver!
        unless current_user.approver?
          redirect_url read_only_url
          return false
        end
      end

      def require_cross_check_not_to_be_aready_started!
        unless workbasket.approve_process_can_be_started?
          redirect_url read_only_url
          return false
        end
      end

      def check_cross_check_permissions!
        unless workbasket.approver_id == current_user.id
          redirect_url read_only_url
          return false
        end
      end
  end
end
