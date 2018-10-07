module Workbaskets
  class CrossChecksController < Workbaskets::WorkflowBaseController

    before_action :require_cross_check_not_to_be_aready_started!, only: [:new]

    expose(:form) do
      WorkbasketForms::CrossCheckForm.new
    end

    expose(:cross_checker) do
      ::WorkbasketInteractions::Workflow::CrossCheck.new(
        current_user, workbasket, params[:cross_check]
      )
    end

    expose(:next_cross_check) do
      current_user.next_workbasket_to_cross_check
    end

    expose(:next_approve) do
      current_user.next_workbasket_to_approve
    end

    def new
      workbasket.assign_cross_checker!(current_user)
    end

    def create
      if cross_checker.valid?
        cross_checker.persist!

        render json: { redirect_url: cross_check_url(workbasket.id) },
                       status: :ok
      else
        render json: {
          errors: cross_checker.errors,
        }, status: :unprocessable_entity
      end
    end

    private

      def require_cross_check_not_to_be_aready_started!
        unless workbasket.cross_check_process_can_be_started?
          redirect_url read_only_url
          return false
        end
      end
  end
end
