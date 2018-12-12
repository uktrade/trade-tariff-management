module MeasureService
  class TrackMeasureSids
    CACHE_KEY_SEPARATOR = "_FM_ALL_IDS_".freeze

    attr_accessor :search_code

    def initialize(search_code)
      @search_code = search_code
    end

    def run
      Rails.cache.write(
        cache_key,
        measure_sids
      )
    end

  private

    def cache_key
      search_code.gsub("_SM_", CACHE_KEY_SEPARATOR)
    end

    def measure_sids
      ::Measures::Search.new(
        search_ops
      ).measure_sids
    end

    def search_ops
      Rails.cache.read(search_code)
    end
  end
end
