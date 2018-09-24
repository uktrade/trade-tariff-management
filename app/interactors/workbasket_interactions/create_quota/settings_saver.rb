module WorkbasketInteractions
  module CreateQuota
    class SettingsSaver < ::WorkbasketInteractions::SettingsSaverBase

      WORKBASKET_TYPE = "CreateQuota"

      attr_accessor :order_number

      def order_number_saver
        @order_number_saver ||= build_order_number!(settings.settings)
      end

      def sub_quota_saver
        @sub_quota_saver ||= WorkbasketServices::QuotaSavers::SubQuota.new(self, settings.settings, order_number)
      end

      def persist!
        @persist = true
        @measure_sids = []
        @quota_period_sids = []

        @order_number = persist_order_number!
        sub_quota_saver.persist!

        quota_periods.map do |position, section_ops|
          save_period_by_type(position, section_ops)
        end

        settings.measure_sids_jsonb = @measure_sids.to_json
        settings.quota_period_sids_jsonb = @quota_period_sids.to_json
        settings.set_searchable_data_for_created_measures! if settings.save
      end

      private

        def build_order_number!(order_number_ops, persist_mode=false)
          ::WorkbasketServices::QuotaSavers::OrderNumber.new(
              self, order_number_ops, persist_mode
          )
        end

        def persist_order_number!
          saver = build_order_number!(settings.settings, true)
          saver.valid?

          saver.order_number
        end

        def save_period_by_type(position, section_ops)
          parent_quota_saver = WorkbasketServices::QuotaSavers::ParentQuota.new(
              self,
              section_ops['parent_quota'],
              settings.settings,
              order_number)
          if parent_quota_saver.associate?
            parent_quota_saver.persist!
          end

          setup_initial_date_range!(section_ops)

          case section_ops['type']
          when "annual"

            section_ops["opening_balances"].map do |k, balance_ops|
              year_start_point = @start_point
              definition = add_period!(section_ops, balance_ops)
              if parent_quota_saver.associate?
                parent_quota_saver.add_period!(
                    definition,
                    k,
                    year_start_point)
              end
            end

          when "bi_annual", "quarterly", "monthly"

            section_ops["opening_balances"].map do |k, opening_balance_ops|
              year_start_point = @start_point
              definition = nil
              opening_balance_ops.map do |target_key, balance_part_ops|
                definition = add_period!(section_ops, balance_part_ops, target_key)
              end
              if parent_quota_saver.associate?
                parent_quota_saver.add_period!(
                    definition,
                    k,
                    year_start_point)
              end

            end

          when "custom"

            section_ops["periods"].map do |k, balance_ops|
              definition = add_custom_period!(section_ops, balance_ops)
              if parent_quota_saver.associate?
                parent_quota_saver.add_period!(
                    definition,
                    k,
                    balance_ops['start_date'].to_date,
                    balance_ops['end_date'].try(:to_date))
              end
            end

          end
        end

        def add_period!(section_ops, balance_ops, target_key=nil)
          balance_ops[:start_point] = @start_point
          balance_ops[:end_point] = @end_point

          quota_ops = if target_key.present?
            [self, target_key, section_ops, balance_ops]
          else
            [self, section_ops, balance_ops]
          end

          period_saver = populator_class_for(section_ops['type']).new(*quota_ops)
          period_saver.persist!

          @quota_period_sids << period_saver.quota_definition.quota_definition_sid

          @start_point, @end_point = period_next_date_generator_class.new(
            section_ops['type'], @end_point
          ).date_range
          sub_quota_saver.add_period!(period_saver.quota_definition)
          period_saver.quota_definition
        end

        def add_custom_period!(section_ops, balance_ops)
          balance_ops[:start_point] = balance_ops['start_date'].to_date
          balance_ops[:end_point] = balance_ops['end_date'].try(:to_date)

          period_saver = populator_class_for(section_ops['type']).new(
            self, section_ops, balance_ops
          )
          period_saver.persist!

          @quota_period_sids << period_saver.quota_definition.quota_definition_sid
          period_saver.quota_definition
        end

        def setup_initial_date_range!(section_ops)
          period_type = section_ops['type']
          return true if period_type == 'custom'

          @start_point = section_ops['start_date'].to_date
          @end_point = @start_point + period_next_date_generator_class.period_length(period_type)
        end

        def populator_class_for(period_type)
          target_klass_name = case period_type
          when "annual"
            "AnnualPeriod"
          when "bi_annual", "quarterly", "monthly"
            "MultiplePartsPeriod"
          when "custom"
            "CustomPeriod"
          end

          "::WorkbasketServices::QuotaSavers::#{target_klass_name}".constantize
        end

        def period_next_date_generator_class
          ::WorkbasketValueObjects::CreateQuota::PeriodNextDateGenerator
        end
    end
  end
end
