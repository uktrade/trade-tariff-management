module Workbaskets
  module Workflows
    class BaseController < ApplicationController
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
        current_user.next_workbasket_to_cross_check(workbasket.id)
      end

      expose(:next_approve) do
        current_user.next_workbasket_to_approve(workbasket.id)
      end

      def create
        if checker.valid?
          checker.persist!

          upload_xml if (workbasket.status == 'awaiting_cds_upload_edit' || workbasket.status == 'awaiting_cds_upload_create_new')

          render "workbaskets/#{workbasket.type}/workflow_screens_parts/status_pages/_#{workbasket.status}"
        else
          @errors = checker.errors
          render :new,  status: :unprocessable_entity
        end
      end

      def upload_xml
        additional_params = {
          workbasket: false,
          workbasket_selected: workbasket.id
        }

        record = XmlExport::File.new(
          {
            issue_date: Time.zone.now,
            state: "P",
            user_id: current_user.id
          }.merge(additional_params)
        )

        record.save_with_envelope_id

        XmlGeneration::ExportWorker.new.perform(record.id)
      end
    end
  end
end
