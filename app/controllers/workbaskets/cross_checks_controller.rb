module Workbaskets
  class CrossChecksController < Workbaskets::WorkflowBaseController

    expose(:form) do
      WorkbasketForms::CrossCheckForm.new
    end

    expose(:cross_checker) do
      ::WorkbasketInteractions::Workflow::CrossCheck.new(
        current_user, workbasket, params
      )
    end

    expose(:next_cross_check) do
      current_user.next_workbasket_to_cross_check
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
  end
end
