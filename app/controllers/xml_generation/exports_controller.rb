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

    def create
      record = klass.new(
        date_filters: date_filters,
        issue_date: Time.zone.now,
        state: "P"
      )

      if record.save
        #worker_klass.perform_async(record.id) unless Rails.env.test?

        ::XmlGeneration::TaricExport.new(record).run

        redirect_to redirect_url,
                    notice: "#{record_name} was successfully scheduled. Please wait!"
      else
        redirect_to redirect_url,
                    notice: "Something wrong!"
      end
    end
  end
end
