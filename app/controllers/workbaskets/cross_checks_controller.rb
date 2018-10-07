module Workbaskets
  class CrossChecksController < Workbaskets::WorkflowBaseController

    expose(:export_date) do
      params[:export_date].try(:to_date)
    end

    def approve
      if workbasket.move_status_to!(
          current_user,
          :ready_for_approval
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
        :cross_check_rejected,
        params[:reasons]
      )
    end
  end
end
