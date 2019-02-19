module Workbaskets
  module Workflows
    class ScheduleExportToCdsController < Workbaskets::Workflows::BaseController
      expose(:export_date) do
        params[:export_date].try(:to_date)
      end

      def create
        workbasket.move_status_to!(
          current_user,
          :awaiting_cds_upload_create_new
        )
      end
    end
  end
end
