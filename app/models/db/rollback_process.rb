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
        data.map do |workbasket|
          workbasket.clean_up_workbasket!
        end
      end

      def mark_job_as_completed!
        record.update(state: "C")
      end
  end
end
