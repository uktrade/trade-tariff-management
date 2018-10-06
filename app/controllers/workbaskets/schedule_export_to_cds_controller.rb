module Workbaskets
  class ScheduleExportToCdsController < Workbaskets::BaseController

    expose(:workbasket) do
      Workbaskets::Workbasket.find(id: params[:id])
    end

    def create
    end
  end
end
