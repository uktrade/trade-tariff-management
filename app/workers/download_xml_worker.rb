require './app/services/xml_generation/download'

class DownloadXmlWorker
  include Sidekiq::Worker

  def perform
    XmlGeneration::Download.new.run
  end
end
