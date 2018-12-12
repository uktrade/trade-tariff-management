module Db
  class RollbackProcess
    attr_accessor :record,
                  :data

    def initialize(record)
      @record = record
    end

    def run
      fetch_relevant_data
      delete_target_db_records!
      mark_job_as_completed!
    end

  private

    def fetch_relevant_data
      start_date = record.date_filters[:start_date].strftime("%Y-%m-%d")
      end_date = record.date_filters[:end_date].strftime("%Y-%m-%d") if record.date_filters[:end_date].present?
      @data = ::Workbaskets::Workbasket.by_date_range(
        start_date, end_date
      )
    end

    def delete_target_db_records!
      data.map(&:clean_up_workbasket!)
      # FIXME: At the moment we have an issue where workflow isn't complete and some records are not linked via
      # the workbasket items model, so they are not cleaned up by the clean_up_workbasket! method.
      # Manually deleting the records for now.
      # There seems to be some database rows without an operation date, so skip published reference data.
      start_date = record.date_filters[:start_date].strftime("%Y-%m-%d")
      Sequel::Model.db.transaction do
        Sequel::Model.subclasses.select { |model|
          model.plugins.include?(Sequel::Plugins::Oplog)
        }.each do |model|
          model.operation_klass.where { operation_date >= start_date }.or(operation_date: nil).exclude(status: 'published').delete
        end
      end
    end

    def mark_job_as_completed!
      record.update(state: "C")
    end
  end
end
