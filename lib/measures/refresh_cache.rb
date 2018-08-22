module Measures
  class RefreshCache

    KEYS_TO_CLEAR = [
      :measures_form_geographical_areas_json,
      :measures_form_geographical_areas,
      :measures_form_geographical_countries,
      :measures_form_geographical_groups_except_erga_omnes,
      :measures_form_geographical_area_erga_omnes
    ]

    class << self
      def run
        notify_via_sentry!("started")

        clear_keys!
        recache_keys!

        notify_via_sentry!("completed")
      end

      def clear_keys!
        KEYS_TO_CLEAR.map do |cache_key|
          Rails.cache.delete(cache_key)
        end
      end

      def recache_keys!
        TimeMachine.at(Date.current) do
          form = MeasureForm.new(Measure.last)

          form.geographical_areas_json
          form.all_geographical_areas
          form.all_geographical_countries
          form.geographical_groups_except_erga_omnes
          form.geographical_area_erga_omnes
        end
      end

      def notify_via_sentry!(message)
        ::Raven.capture_exception(
          "[RefreshCacheWorker] #{message}!"
        )
      end
    end
  end
end
