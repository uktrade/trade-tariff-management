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
      case workbasket.type
      when "create_measures"
        create_measure_url(workbasket.id)
      end
    end

    expose(:form) do
      WorkbasketForms::WorkflowForm.new
    end

    expose(:next_cross_check) do
      current_user.next_workbasket_to_cross_check
    end

    expose(:next_approve) do
      current_user.next_workbasket_to_approve
    end

    def create
      if checker.valid?
        checker.persist!

        render json: { redirect_url: check_completed_url },
                       status: :ok
      else
        render json: {
          errors: checker.errors,
        }, status: :unprocessable_entity
      end
    end
  end
end
