module Db
  class RollbackWorker
    include Sidekiq::Worker

    sidekiq_options queue: :xml_generation, retry: false

    def perform(record_id)
      record = ::Db::Rollback.filter(id: record_id).first
      ::Db::RollbackProcess.new(record).run
    end
  end
end
