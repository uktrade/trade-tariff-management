module Workbaskets
  class WorkflowBaseController < ApplicationController

    expose(:workbasket) do
      Workbaskets::Workbasket.find(id: params[:id])
    end
  end
end
