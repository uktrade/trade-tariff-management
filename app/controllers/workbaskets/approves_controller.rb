module Workbaskets
  class ApprovesController < Workbaskets::WorkflowBaseController

    expose(:export_date) do
      params[:export_date].try(:to_date)
    end

    def approve
      if workbasket.move_status_to!(
          current_user,
          workbasket.possible_approved_status
        )

        if export_date.present?
          workbasket.operation_date = export_date
          workbasket.save
        end
      end
    end

    def reject
      workbasket.move_status_to!(
        current_user,
        :approval_rejected,
        params[:reasons]
      )
    end
  end
end
