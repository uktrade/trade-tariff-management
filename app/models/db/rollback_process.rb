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
        @data = ::XmlGeneration::Search.new(
          record.clear_date
        ).send(:data)
      end

      def delete_target_db_records!
        data.map do |item|
          item.manual_add = true
          item.delete
        end
      end

      def mark_job_as_completed!
        record.update(state: "C")
      end
  end
end
