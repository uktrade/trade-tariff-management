module QuotaService
  class FetchQuotaSids

    attr_accessor :search_code,
                  :selection_type,
                  :quota_sids

    def initialize(params={})
      @search_code = params[:search_code].gsub(
        "_SQ_", ::QuotaService::TrackQuotaSids::CACHE_KEY_SEPARATOR
      )
      @selection_type = params[:selection_type]
      @quota_sids = params[:quota_sids] || []
    end

    def ids
      case selection_type
      when 'all'
        #
        # if selection_type is `all`, then `measure_sids` contains exclusions
        #

        all_quota_sids - quota_sids
      when 'none'
        #
        # if selection_type is `none` then `measure_sids` contains selection
        #

        quota_sids
      end
    end

    private

      def all_quota_sids
        Rails.cache.read(search_code)
      end
  end
end
