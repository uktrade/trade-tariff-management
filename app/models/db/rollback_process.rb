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
        @data = ::XmlGeneration::WorkbasketSearch.new(
          record.date_filters
        ).send(:data)
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
