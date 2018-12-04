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

    expose(:default_start_date) do
      Workbaskets::Workbasket.first_operation_date || Date.today
    end

    expose(:default_end_date) do
      Date.today
    end
  end
end
