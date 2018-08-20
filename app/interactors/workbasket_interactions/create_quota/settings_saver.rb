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
          self, settings.settings, persist_mode?
        )
      end

      def persist!
        @persist = true
        @measure_sids = []
        @quota_period_sids = []

        quota_periods.map do |position, section_ops|
          @start_point = section_ops['start_date'].to_date
          @end_point = start_point + 1.year

          section_ops["opening_balances"].map do |k, balance_ops|
            balance_ops[:start_point] = @start_point
            balance_ops[:end_point] = @end_point

            period_saver = ::WorkbasketServices::QuotaSavers::Period.new(
              self, section_ops, balance_ops
            )
            period_saver.persist!

            @quota_period_sids << period_saver.quota_definition.quota_definition_sid

            @start_point = @end_point + 1.day
            @end_point = @start_point + 1.year
          end
        end

        settings.measure_sids_jsonb = @measure_sids.to_json
        settings.quota_period_sids_jsonb = @quota_period_sids.to_json
        settings.set_searchable_data_for_created_measures! if settings.save
      end

      private

        def persist_mode?
          step_pointer.review_and_submit_step?
        end
    end
  end
end
