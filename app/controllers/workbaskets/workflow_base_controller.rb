module Workbaskets
  class WorkflowBaseController < ApplicationController

    around_action :configure_time_machine

    expose(:workbasket) do
      Workbaskets::Workbasket.find(id: params[:id])
    end

    expose(:workbasket_settings) do
      workbasket.settings
    end

    def attributes_parser
      "::WorkbasketValueObjects::#{workbasket.class}::AttributesParser".constantize.new(
        workbasket_settings,
        :review_and_submit
      )
    end
  end
end
