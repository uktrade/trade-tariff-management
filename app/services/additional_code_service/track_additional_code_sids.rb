module AdditionalCodeService
  class TrackAdditionalCodeSids

    CACHE_KEY_SEPARATOR = "_FAD_ALL_IDS_"

    attr_accessor :search_code

    def initialize(search_code)
      @search_code = search_code
    end

    def run
      Rails.cache.write(
        cache_key,
        additional_code_sids
      )
    end

    private

      def cache_key
        search_code.gsub("_SAD_", CACHE_KEY_SEPARATOR)
      end

      def additional_code_sids
        ::AdditionalCodes::Search.new(
          search_ops
        ).additional_code_sids
      end

      def search_ops
        Rails.cache.read(search_code)
      end
  end
end
