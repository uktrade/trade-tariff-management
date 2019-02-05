module Db
  class RollbacksController < ApplicationController
    include ::BaseJobMixin

    around_action :configure_time_machine

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

    expose(:additional_params) do
      {
        date_filters: date_filters
      }
    end

    expose(:default_start_date) do
      Workbaskets::Workbasket.first_operation_date || Date.today
    end

    expose(:default_end_date) do
      Date.today
    end


    private

    def date_filters
      ops = {}

      ops[:start_date] = params[:start_date].try(:to_date) || Date.today
      ops[:end_date] = params[:end_date].try(:to_date) if params[:end_date].present?

      ops
    end

    def persist_record(record)
      record.save
    end
  end
end
