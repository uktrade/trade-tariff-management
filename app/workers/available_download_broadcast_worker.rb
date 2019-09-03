class AvailableDownloadBroadcastWorker
  include Sidekiq::Worker

  def perform(uuid, search_code=nil)
    ActionCable.server.broadcast(
      "downloads_channel_#{uuid}", csv: MeasureService::DownloadMeasures.call(search_code)
    )
  end
end
