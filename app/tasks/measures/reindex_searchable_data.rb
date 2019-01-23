module Measures
  class ReindexSearchableData
    LIMIT = 2500

    attr_accessor :total,
                  :offset

    def initialize(offset_start = nil)
      @total = Measure.searchable_data_not_indexed.count
      @offset = offset_start || 1
    end

    def run
      while offset < total do
        query
        @offset += LIMIT
      end
    end

    def query
      records = Measure.searchable_data_not_indexed
                       .offset(offset)
                       .limit(LIMIT)

      records.map(&:set_searchable_data!)

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
