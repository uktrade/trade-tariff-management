#
# THIS TASK IS FOR TEMPORARY PURPOSES
#
# TODO: remove me after you update all existing record on DEV and STAGING servers
#

module Measures
  class SetPublishedStatus

    LIMIT = 2500

    attr_accessor :total,
                  :offset

    def initialize(offset_start=nil)
      @total = Measure.without_status.count
      @offset = offset_start || 1
    end

    def run
      while offset < total do
        query
        @offset += LIMIT
      end
    end

    def query
      records = Measure.without_status
                       .offset(offset)
                       .limit(LIMIT)

      records.map do |record|
        record.manual_add = true
        record.status = "published"

        record.save
      end

      log_it(records.sql)

      sleep 1
    end

    private

      def log_it(sql)
        p ""
        p "-" * 100
        p ""
        p "COVERED #{offset} FROM #{total}"
        p ""
        p "SQL: #{sql}"
        p ""
        p "-" * 100
        p ""
      end
  end
end
