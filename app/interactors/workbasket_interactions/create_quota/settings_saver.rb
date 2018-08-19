module WorkbasketInteractions
  module CreateQuota
    class SettingsSaver < ::WorkbasketInteractions::SettingsSaverBase

      WORKBASKET_TYPE = "CreateQuota"

      ASSOCIATION_LIST = %w(
        measure_components
        conditions
        footnotes
        excluded_geographical_areas
      )

      ASSOCIATION_LIST.map do |name|
        define_method("#{name}_errors") do |measure|
          get_association_errors(name, measure)
        end
      end

      def order_number_saver
        @order_number_saver ||= ::WorkbasketServices::QuotaSavers::OrderNumber.new(
          self, settings.settings
        )
      end

      def quota_periods_saver
        @quota_periods_saver ||= ::WorkbasketServices::QuotaSavers::QuotaPeriods.new(
          self, settings.settings
        )
      end

      def persist!
        @persist = true
        @measure_sids = []

        quota_periods_saver.persist!

        settings.measure_sids_jsonb = @measure_sids.to_json
        settings.quota_period_sids_jsonb = quota_periods_saver.quota_period_sids.to_json
        settings.set_searchable_data_for_created_measures! if settings.save
      end
    end
  end
end
