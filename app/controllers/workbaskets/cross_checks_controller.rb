module Workbaskets
  class CrossChecksController < Workbaskets::WorkflowBaseController

    expose(:form) do
      WorkbasketForms::CrossCheckForm.new
    end

    def create
      if params[:mode] == "approve"
        approve
      else
        reject
      end
    end

    private

      def approve
        if workbasket.move_status_to!(
            current_user,
            :ready_for_approval
          )
        end
      end

      def reject
        workbasket.move_status_to!(
          current_user,
          :cross_check_rejected,
          params[:reasons]
        )
      end
  end
end
