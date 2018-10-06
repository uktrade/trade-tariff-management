module Workbaskets
  class WorkflowBaseController < ApplicationController

    around_action :configure_time_machine

    expose(:workbasket) do
      Workbaskets::Workbasket.find(id: params[:id])
    end
  end
end
