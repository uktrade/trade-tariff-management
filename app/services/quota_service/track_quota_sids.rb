module QuotaService
  class TrackQuotaSids

    CACHE_KEY_SEPARATOR = "_FQ_ALL_IDS_"

    attr_accessor :search_code

    def initialize(search_code)
      @search_code = search_code
    end

    def run
      Rails.cache.write(
        cache_key,
        quota_sids
      )
    end

    private

      def cache_key
        search_code.gsub("_SQ_", CACHE_KEY_SEPARATOR)
      end

      def quota_sids
        ::Quotas::Search.new(
          search_ops
        ).quota_sids
      end

      def search_ops
        Rails.cache.read(search_code)
      end
  end
end
