module WorkbasketServices
  module QuotaSavers
    class ParentQuota

      attr_accessor :settings_saver,
                    :ops,
                    :base_params,
                    :sub_quota,
                    :order_number

      def initialize(settings_saver, parent_quota_ops, base_params, sub_quota)
        @settings_saver = settings_saver
        @ops = parent_quota_ops
        @base_params = base_params
        @base_params['quota_ordernumber'] = parent_quota_ops['order_number']
        @sub_quota = sub_quota
        @order_number = nil
      end

      def associate?
        ops['associate']
      end

      def persist!
        saver = build_order_number!(base_params)
        saver.valid?
        @order_number = saver.order_number

        build_quota_association!
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
      end

      private
        def build_order_number!(order_number_ops)
          ::WorkbasketServices::QuotaSavers::OrderNumber.new(
              settings_saver, order_number_ops, true
          )
        end

        def build_quota_association!
          QuotaAssociation.unrestrict_primary_key
          association = QuotaAssociation.new(
              main_quota_definition_sid: order_number.quota_order_number_sid,
              sub_quota_definition_sid: sub_quota.quota_order_number_sid,
              relation_type: 'NM',
              coefficient: 1,
          )
          settings_saver.assign_system_ops!(association)
          association.save
        end
    end
  end
end