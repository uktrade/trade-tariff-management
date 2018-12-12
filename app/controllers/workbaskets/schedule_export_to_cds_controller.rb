module Workbaskets
  class ScheduleExportToCdsController < Workbaskets::WorkflowBaseController
    expose(:export_date) do
      params[:export_date].try(:to_date)
    end

    def create
      if export_date.present?
        workbasket.operation_date = export_date

        if workbasket.save
          workbasket.move_status_to!(
            current_user,
            :awaiting_cds_upload_create_new
          )
        end
      end
    end
  end
end
