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
        # cannot select locked measures.
        unlocked_measure_sids - measure_sids.map(&:to_i)
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

    def unlocked_measure_sids
      Measure.where(measure_sid: all_measure_sids).where("status = 'published'").pluck(:measure_sid)
    end
  end
end
