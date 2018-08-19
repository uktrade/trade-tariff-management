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
        #
        # TODO: refactor me Ruslan!
        #

        @persist = true
        @measure_sids = []
        @quota_period_sids = []

        Rails.logger.info ""
        Rails.logger.info "PERSIST CALLED"
        Rails.logger.info ""

        all_settings = settings.settings



        Rails.logger.info ""
        Rails.logger.info "FIRST PERIOD START: #{first_period_start_date}"
        Rails.logger.info ""

        periods.map do |position, section_ops|

          start_point = section_ops['start_date'].to_date
          end_point = start_point + 1.year

          section_ops["opening_balances"].map do |k, opening_balance_ops|

            Rails.logger.info ""
            Rails.logger.info "k: #{k}"
            Rails.logger.info ""
            Rails.logger.info "opening_balance_ops: #{opening_balance_ops.inspect}"
            Rails.logger.info ""

            source = section_ops["criticality_each_period"] == "true" ? opening_balance_ops : section_ops
            critical = source["critical"] == "true" ? "Y" : "N"
            critical_threshold = source["criticality_threshold"].to_i

            balance_source = section_ops["staged"] == "true" ? opening_balance_ops : section_ops
            balance = balance_source["balance"]

            if balance.present?
              quota_definition_ops = {
                quota_order_number_id: quota_order_number.quota_order_number_id,
                quota_order_number_sid: quota_order_number.quota_order_number_sid,
                critical_threshold: critical_threshold,
                critical_state: critical,
                description: all_settings['quota_description'],
                measurement_unit_code: section_ops["measurement_unit_code"],
                measurement_unit_qualifier_code: section_ops["measurement_unit_qualifier_code"],
                volume: balance.to_i,
                initial_volume: balance.to_i,
                validity_start_date: start_point,
                validity_end_date: end_point
              }

              quota_definition = QuotaDefinition.new(quota_definition_ops)

              quota_definition = assign_system_ops!(quota_definition)
              set_primary_key(quota_definition)

              quota_definition.save

              @quota_period_sids << quota_definition.quota_definition_sid

              duties_source = section_ops["duties_each_period"] == "true" ? opening_balance_ops : section_ops

              period_measure_components = {}

              duties_source["duty_expressions"].select do |k, option|
                option["duty_expression_id"].present?
              end.map do |k, duty_expression_ops|
                period_measure_components[k] = ActiveSupport::HashWithIndifferentAccess.new(duty_expression_ops)
              end

              candidates.map do |code|
                attrs_parser.instance_variable_set(:@start_date, start_point)
                attrs_parser.instance_variable_set(:@end_date, end_point)
                attrs_parser.instance_variable_set(:@measure_components, period_measure_components) if period_measure_components.present?

                candidate_validation_errors(code, validation_mode)
              end

              start_point = end_point + 1.day
              end_point = start_point + 1.year
            end
          end
        end

        settings.measure_sids_jsonb = @measure_sids.to_json
        settings.quota_period_sids_jsonb = @quota_period_sids.to_json

        if settings.save
          settings.set_searchable_data_for_created_measures!
        end
      end
    end
  end
end
