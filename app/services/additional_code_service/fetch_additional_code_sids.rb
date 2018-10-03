module AdditionalCodeService
  class FetchAdditionalCodeSids

    attr_accessor :search_code,
                  :selection_type,
                  :additional_code_sids

    def initialize(params={})
      @search_code = params[:search_code].gsub(
        "_SAD_", ::AdditionalCodeService::TrackAdditionalCodeSids::CACHE_KEY_SEPARATOR
      )
      @selection_type = params[:selection_type]
      @additional_code_sids = params[:item_sids] || []
    end

    def ids
      case selection_type
      when 'all'
        #
        # if selection_type is `all`, then `measure_sids` contains exclusions
        #

        all_additional_code_sids - additional_code_sids
      when 'none'
        #
        # if selection_type is `none` then `measure_sids` contains selection
        #

        additional_code_sids
      end
    end

    private

      def all_additional_code_sids
        Rails.cache.read(search_code)
      end
  end
end
