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

  private

    def persist_record(record)
      record.save_with_envelope_id
    end
  end
end
