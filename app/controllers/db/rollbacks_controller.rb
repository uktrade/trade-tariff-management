module Db
  class RollbacksController < ApplicationController

    include ::BaseJobMixin

    expose(:record_name) do
      "Rollback"
    end

    expose(:klass) do
      ::Db::Rollback
    end

    expose(:worker_klass) do
      ::Db::RollbackWorker
    end

    expose(:redirect_url) do
      db_rollbacks_path
    end
  end
end
