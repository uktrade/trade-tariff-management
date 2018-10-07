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

    def create
      if cross_checker.valid?
        cross_checker.persist!

        render json: { redirect_url: redirect_url },
                       status: :ok
      else
        render json: {
          errors: cross_checker.errors,
        }, status: :unprocessable_entity
      end
    end

    private

      def redirect_url

      end
  end
end
