module MeasureService
  class TrackMeasureSids

    CACHE_KEY_SEPARATOR = "FM_ALL_IDS"

    attr_accessor :current_user,
                  :search_code

    def initialize(current_user, search_code)
      @current_user = current_user
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
        "#{current_user.id}_#{CACHE_KEY_SEPARATOR}_#{Time.now.to_i}"
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
