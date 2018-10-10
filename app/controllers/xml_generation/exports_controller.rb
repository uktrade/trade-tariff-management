module XmlGeneration
  class ExportsController < ApplicationController

    include ::BaseJobMixin

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
      puts "params call #{params[:workbasket]}"
      {workbasket: params[:workbasket] == 'on'}
    end
  end
end
