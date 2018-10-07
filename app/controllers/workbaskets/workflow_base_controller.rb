module Workbaskets
  class WorkflowBaseController < ApplicationController

    around_action :configure_time_machine

    expose(:workbasket) do
      Workbaskets::Workbasket.find(id: params[:id])
    end

    expose(:workbasket_settings) do
      workbasket.settings
    end

    expose(:attributes_parser) do
      "::WorkbasketValueObjects::#{workbasket.class_name}::AttributesParser".constantize.new(
        workbasket_settings,
        :review_and_submit
      )
    end

    expose(:read_only_url) do
      public_send("#{workbasket.type}_url", workbasket.id)
    end
  end
end
