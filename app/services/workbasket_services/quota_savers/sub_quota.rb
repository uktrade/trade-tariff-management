module WorkbasketServices
  module QuotaSavers
    class SubQuota
      attr_accessor :settings_saver,
                    :attrs_parser,
                    :all_settings,
                    :ops,
                    :base_params,
                    :order_numbers,
                    :errors

      def initialize(settings_saver, base_params)
        @errors = {}
        @settings_saver = settings_saver
        @all_settings = settings_saver.settings
                                      .settings
        @attrs_parser = settings_saver.attrs_parser
        @ops = filtered_ops(base_params['sub_quotas']) || []
        @base_params = base_params
        @order_numbers = []
      end

      def valid?
        ops.each do |index, item|
          if item['order_number'].blank?
            @errors["sub_quota_order_number_#{index}"] = "\##{index.to_i + 1} - Order number can't be blank"
          else
            params = base_params
            base_params['quota_ordernumber'] = item['order_number']
            saver = build_order_number!(params, false)
            saver.generate_records!
            ::WorkbasketValueObjects::Shared::ConformanceErrorsParser.new(
              saver.order_number, QuotaOrderNumberValidator, {}
).errors.map do |key, error|
              @errors.merge!("#{key.join(',')}_#{index}": "\##{index.to_i + 1} - #{error.join('. ')}")
            end
          end

          @errors["sub_quota_commodity_codes_#{index}"] = "\##{index.to_i + 1} - Commodity codes can't be blank" if item['commodity_codes'].blank?
          @errors["sub_quota_coefficient_#{index}"] = "\##{index.to_i + 1} - Coefficient can't be blank" if item['coefficient'].blank?
        end

        errors.blank?
      end

      def persist!
        @order_numbers = ops.map do |_index, item|
          params = base_params
          base_params['quota_ordernumber'] = item['order_number']
          saver = build_order_number!(params)
          saver.valid?
          saver.order_number
        end
      end

      def add_period!(source_definition, section_ops, balance_ops)
        @section_ops = section_ops
        @balance_ops = balance_ops
        quota_period_sids = []
        order_numbers.each_with_index do |order_number, index|
          definition = QuotaDefinition.new(
            volume: source_definition.volume,
            initial_volume: source_definition.initial_volume,
            validity_start_date: source_definition.validity_start_date,
            validity_end_date: source_definition.validity_end_date,
            critical_state: source_definition.critical_state,
            critical_threshold: source_definition.critical_threshold,
            description: source_definition.description,
            quota_order_number_id: order_number.quota_order_number_id,
            quota_order_number_sid: order_number.quota_order_number_sid,
            measurement_unit_code: source_definition.measurement_unit_code,
            measurement_unit_qualifier_code: source_definition.measurement_unit_qualifier_code,
            workbasket_type_of_quota: source_definition.workbasket_type_of_quota,
            maximum_precision: all_settings["quota_precision"]
          )
          ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(definition).assign!
          settings_saver.assign_system_ops!(definition)
          if definition.save
            build_quota_association!(
              source_definition,
                definition,
                ops[index.to_s]['coefficient'].to_f
            )
            add_measures_for_definition!(
              parse_commodity_codes(ops[index.to_s]['commodity_codes']),
                order_number.quota_order_number_id,
                source_definition.validity_start_date,
                source_definition.validity_end_date
)
            quota_period_sids << definition.quota_definition_sid
          end
        end
        quota_period_sids
      end

    private

      def filtered_ops(ops)
        if ops.present?
          ops.select do |_key, item|
            item['coefficient'].present? || item['order_number'].present? || item['commodity_codes'].present?
          end
        end
      end

      def parse_commodity_codes(commodity_codes)
        if commodity_codes.present?
          commodity_codes.split(/[\s|,]+/)
              .map(&:strip)
              .reject(&:blank?)
              .uniq
        end
      end

      def build_order_number!(order_number_ops, persist = true)
        ::WorkbasketServices::QuotaSavers::OrderNumber.new(
          settings_saver, order_number_ops, persist
        )
      end

      def build_quota_association!(main_definition, sub_definition, coefficient)
        QuotaAssociation.unrestrict_primary_key
        association = QuotaAssociation.new(
          main_quota_definition_sid: main_definition.quota_definition_sid,
          sub_quota_definition_sid: sub_definition.quota_definition_sid,
          relation_type: 'EQ',
          coefficient: coefficient,
        )
        settings_saver.assign_system_ops!(association)
        association.save
      end

      def add_measures_for_definition!(goods_nomenclature_codes, quota_order_number, start_point, end_point)
        Array.wrap(base_params['geographical_area_id']).each do |geographical_area_id|
          Array.wrap(goods_nomenclature_codes).each do |goods_nomenclature_code|
            attrs_parser.instance_variable_set(:@start_date, start_point)
            attrs_parser.instance_variable_set(:@end_date, end_point)
            attrs_parser.instance_variable_set(:@quota_order_number, quota_order_number)
            if period_measure_components.present?
              attrs_parser.instance_variable_set(
                :@measure_components,
                  period_measure_components
              )
            end
            settings_saver.send(:candidate_validation_errors,
                geographical_area_id: geographical_area_id,
                goods_nomenclature_code: goods_nomenclature_code,)
            attrs_parser.instance_variable_set(:@quota_order_number, nil)
          end
        end
      end

      def period_measure_components
        measure_components = {}

        duty_expression_list.select do |_k, option|
          option["duty_expression_id"].present?
        end.map do |k, duty_expression_ops|
          measure_components[k] = ActiveSupport::HashWithIndifferentAccess.new(
            duty_expression_ops
          )
        end

        measure_components
      end

      def duty_expression_list
        source("duties_each_period")["duty_expressions"]
      end

      def source(key)
        @section_ops[key] == "true" || @section_ops["type"] == "custom" ? @balance_ops : @section_ops
      end
    end
  end
end
