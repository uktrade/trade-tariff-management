module MeasureService
  class DownloadMeasures
    class << self
      def call(search_code)
        CSV.generate(headers: false) do |csv|
          csv << Measure.table_array_headers
          ::Measures::Search.new(
            Rails.cache.read(search_code)
          ).results(false).map do |measure|
            csv << measure.to_table_array
          end
        end
      end
    end
  end
end
