module WorkbasketServices
  module QuotaSavers
    class QuotaPeriods < ::WorkbasketServices::Base

      attr_accessor :saver_class,
                    :attrs_parser,
                    :all_settings,
                    :quota_order_number,
                    :periods,
                    :start_point,
                    :end_point

      def initialize(saver_class, all_settings)
        @saver_class = saver_class
        @attrs_parser = saver_class.attrs_parser
        @all_settings = all_settings
        @periods = saver_class.quota_periods
        @quota_order_number = saver_class.order_number_saver
                                         .order_number
      end

      def persist!
        periods.map do |position, section_ops|
          @start_point = section_ops['start_date'].to_date
          @end_point = start_point + 1.year

          section_ops["opening_balances"].map do |k, opening_balance_ops|

            Rails.logger.info ""
            Rails.logger.info "k: #{k}"
            Rails.logger.info ""
            Rails.logger.info "opening_balance_ops: #{opening_balance_ops.inspect}"
            Rails.logger.info ""

            add_definition!(
              section_ops,
              opening_balance_ops
            )
          end
        end
      end

      private

        def add_definition!(section_ops, opening_balance_ops)
          source = section_ops["criticality_each_period"] == "true" ? opening_balance_ops : section_ops
          critical = source["critical"] == "true" ? "Y" : "N"
          critical_threshold = source["criticality_threshold"].to_i

          balance_source = section_ops["staged"] == "true" ? opening_balance_ops : section_ops
          balance = balance_source["balance"]

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

          add_measures_for_definition!(period_measure_components)

          @start_point = end_point + 1.day
          @end_point = start_point + 1.year
        end

        def add_measures_for_definition!(period_measure_components)
          saver_class.candidates.map do |code|
            attrs_parser.instance_variable_set(:@start_date, start_point)
            attrs_parser.instance_variable_set(:@end_date, end_point)

            if period_measure_components.present?
              attrs_parser.instance_variable_set(
                :@measure_components,
                period_measure_components
              )
            end

            saver_class.candidate_validation_errors(code, validation_mode)
          end
        end

        def period_measure_components
          period_measure_components = {}

          duties_source["duty_expressions"].select do |k, option|
            option["duty_expression_id"].present?
          end.map do |k, duty_expression_ops|
            period_measure_components[k] = ActiveSupport::HashWithIndifferentAccess.new(duty_expression_ops)
          end
        end
    end
  end
end
