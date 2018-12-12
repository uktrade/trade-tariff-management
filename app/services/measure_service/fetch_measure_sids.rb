module MeasureService
  class FetchMeasureSids
    attr_accessor :search_code,
                  :selection_type,
                  :measure_sids

    def initialize(params = {})
      @search_code = params[:search_code].gsub(
        "_SM_", ::MeasureService::TrackMeasureSids::CACHE_KEY_SEPARATOR
      )
      @selection_type = params[:selection_type]
      @measure_sids = params[:measure_sids] || []
    end

    def ids
      case selection_type
      when 'all'
        #
        # if selection_type is `all`, then `measure_sids` contains exclusions
        #

        all_measure_sids - measure_sids
      when 'none'
        #
        # if selection_type is `none` then `measure_sids` contains selection
        #

        measure_sids
      end
    end

  private

    def all_measure_sids
      Rails.cache.read(search_code)
    end
  end
end
