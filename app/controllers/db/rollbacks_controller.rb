module Db
  class RollbacksController < ApplicationController

    expose(:rollbacks) do
      Db::RollbackDecorator.decorate_collection(
        Db::Rollback.reverse_order(:clear_date)
                        .page(params[:page])
      )
    end

    def create
      record = ::Db::Rollback.new(
        clear_date: clear_date,
        issue_date: Time.zone.now,
        state: "P"
      )

      if record.save
        ::Db::RollbackWorker.perform_async(record.id) unless Rails.env.test?

        redirect_to db_rollbacks_path,
                    notice: "Rollback was successfully scheduled for #{record.clear_date.to_formatted_s(:uk)}. Please wait!"
      else
        redirect_to db_rollbacks_path,
                    notice: "Something wrong!"
      end
    end

    private

      def clear_date
        params[:clear_date].try(:to_date) || Date.today
      end
  end
end
