module WorkbasketServices
  module QuotaSavers
    class ParentQuota

      attr_accessor :settings_saver,
                    :ops,
                    :base_params,
                    :sub_quota,
                    :order_number,
                    :errors

      def initialize(settings_saver, parent_quota_ops, base_params, sub_quota)
        @errors = {}
        @settings_saver = settings_saver
        @ops = parent_quota_ops
        @base_params = base_params
        @base_params['quota_ordernumber'] = parent_quota_ops['order_number']
        @sub_quota = sub_quota
        @order_number = nil
      end

      def associate?
        ops['associate'] == 'true'
      end

      def valid?
        if associate?

          record = QuotaOrderNumber.new(quota_order_number_id: ops['order_number'])
          ::WorkbasketValueObjects::Shared::ConformanceErrorsParser.new(
              record, QuotaOrderNumberValidator, {}).errors.map do |key, error|
            @errors.merge!("#{key.join(',')}": error.join('. '))
          end


          ops['balances'].each do |index, balance|
            value = balance['balance']
            @errors["quota_balance_#{index}"] = "\##{index.to_i + 1} - Opening balance can't be blank" if value.blank?
          end

        end
        errors.blank?
      end

      def persist!
        saver = build_order_number!(base_params)
        saver.valid?
        @order_number = saver.order_number
      end

      def add_period!(source_definition, index, start_date, end_date = nil)
        balance = ops['balances'][index]['balance']
        definition = QuotaDefinition.new(
            volume: balance,
            initial_volume: balance,
            validity_start_date: start_date,
            validity_end_date: end_date.present? ? end_date : start_date + 1.year,
            critical_state: source_definition.critical_state,
            critical_threshold: source_definition.critical_threshold,
            description: source_definition.description,
            quota_order_number_id: order_number.quota_order_number_id,
            quota_order_number_sid: order_number.quota_order_number_sid,
            measurement_unit_code: source_definition.measurement_unit_code,
            measurement_unit_qualifier_code: source_definition.measurement_unit_qualifier_code,
            workbasket_type_of_quota: source_definition.workbasket_type_of_quota
        )
        ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(definition).assign!
        settings_saver.assign_system_ops!(definition)
        definition.save
        definition
      end

      def build_quota_association!(main_definition, sub_definition)
        QuotaAssociation.unrestrict_primary_key
        association = QuotaAssociation.new(
            main_quota_definition_sid: main_definition.quota_definition_sid,
            sub_quota_definition_sid: sub_definition.quota_definition_sid,
            relation_type: 'NM',
            coefficient: 1,
        )
        settings_saver.assign_system_ops!(association)
        association.save
      end

      private
        def build_order_number!(order_number_ops)
          ::WorkbasketServices::QuotaSavers::OrderNumber.new(
              settings_saver, order_number_ops, true
          )
        end
    end
  end
end