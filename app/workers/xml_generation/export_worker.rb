module XmlGeneration
  class ExportWorker
    include Sidekiq::Worker

    sidekiq_options queue: :xml_generation, retry: false

    def perform(record_id, mode)
      record = ::XmlExport::File.filter(id: record_id).first
      ::XmlGeneration::TaricExport.new(record, mode).run
    end
  end
end
