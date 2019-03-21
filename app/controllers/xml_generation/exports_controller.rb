module XmlGeneration
  class ExportsController < ApplicationController
    include ::BaseJobMixin

    around_action :configure_time_machine

    expose(:record_name) do
      "Export"
    end

    expose(:klass) do
      ::XmlExport::File
    end

    expose(:worker_klass) do
      ::XmlGeneration::ExportWorker
    end

    expose(:redirect_url) do
      xml_generation_exports_path
    end

    expose(:additional_params) do
      {
        workbasket: params[:workbasket] == 'on',
        workbasket_selected: params[:workbasket_id]
      }
    end

    expose(:default_start_date) do
      nil
    end

    expose(:default_end_date) do
      nil
    end

    def create
      if valid_workbasket?
        super
      else
        render :index
      end
    end

  private

    def valid_workbasket?
      if Workbaskets::Workbasket[params[:workbasket_id]].present?
        unless Workbaskets::Workbasket[params[:workbasket_id]].ready_for_upload
          @form_error= "Workbasket status must be 'Awaiting CDS upload', currently it is '#{Workbaskets::Workbasket[params[:workbasket_id]].status.humanize}'."
        end
      else
        @form_error= "Cannot find Workbasket '#{params[:workbasket_id]}'."
      end
      @form_error.blank?
    end

    def persist_record(record)
      record.save_with_envelope_id
    end
  end
end
