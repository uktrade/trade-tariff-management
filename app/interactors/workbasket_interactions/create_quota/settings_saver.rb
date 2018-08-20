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

      def persist!
        @persist = true
        @measure_sids = []

        quota_periods.map do |position, section_ops|
          @start_point = section_ops['start_date'].to_date
          @end_point = start_point + 1.year

          section_ops["opening_balances"].map do |k, balance_ops|
            balance_ops[:start_point] = @start_point
            balance_ops[:end_point] = @end_point

            Rails.logger.info ""
            Rails.logger.info "k: #{k}"
            Rails.logger.info ""
            Rails.logger.info "balance_ops: #{balance_ops.inspect}"
            Rails.logger.info ""

            ::WorkbasketServices::QuotaSavers::Period.new(
              self, section_ops, balance_ops
            )

            @start_point = @end_point + 1.day
            @end_point = @start_point + 1.year
          end
        end

        settings.measure_sids_jsonb = @measure_sids.to_json
        settings.quota_period_sids_jsonb = quota_periods_saver.quota_period_sids.to_json
        settings.set_searchable_data_for_created_measures! if settings.save
      end
    end
  end
end
