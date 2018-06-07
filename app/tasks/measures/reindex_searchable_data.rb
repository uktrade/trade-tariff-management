module Measures
  class ReindexSearchableData

    attr_accessor :total,
                  :offset,
                  :limit

    def initialize(offset_start=nil)
      @total = Measure.searchable_data_not_indexed.count
      @offset = offset_start || 1
      @limit = 5000
    end

    def run
      while offset < total do
        query
        @offset += limit
      end
    end

    def query
      records = Measure.searchable_data_not_indexed
                       .offset(offset)
                       .limit(limit)

      records.map do |record|
        reindex_measure!(record)
      end

      log_it(records.sql)

      sleep 1
    end

    private

      def reindex_measure!(record)
        record.set_searchable_data!
        record.save
      end

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
