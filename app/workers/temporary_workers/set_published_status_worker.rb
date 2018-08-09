#
# THIS TASK IS FOR TEMPORARY PURPOSES
#
# TODO: remove me after you update all existing record on DEV and STAGING servers
#
# use: ::TemporaryWorkers::SetPublishedStatusWorker.perform_async
#

module TemporaryWorkers
  class SetPublishedStatusWorker
    include Sidekiq::Worker

    sidekiq_options queue: :default, retry: 5

    def perform
      ::Measures::SetPublishedStatus.new.run
    end
  end
end
