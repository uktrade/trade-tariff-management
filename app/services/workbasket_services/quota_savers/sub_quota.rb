module WorkbasketServices
  module QuotaSavers
    class SubQuota

      attr_accessor :settings_saver,
                    :ops,
                    :base_params,
                    :parent_quota,
                    :order_numbers

      def initialize(settings_saver, base_params, parent_quota)
        @settings_saver = settings_saver
        @ops = base_params['sub_quotas'] || []
        @base_params = base_params
        @parent_quota = parent_quota
        @order_numbers = []
      end

      def persist!
        @order_numbers = ops.map do |index, item|
          params = base_params
          base_params['quota_ordernumber'] = item['order_number']
          saver = build_order_number!(params)
          saver.valid?
          build_quota_association!(saver.order_number, item['coefficient'].to_f)
          saver.order_number
        end
      end

      def add_period!(source_definition)
        order_numbers.each do |order_number|
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
              workbasket_type_of_quota: source_definition.workbasket_type_of_quota
          )
          ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(definition).assign!
          settings_saver.assign_system_ops!(definition)
          definition.save
        end
      end

      private
      def build_order_number!(order_number_ops)
        ::WorkbasketServices::QuotaSavers::OrderNumber.new(
            settings_saver, order_number_ops, true
        )
      end

      def build_quota_association!(sub_quota, coefficient)
        QuotaAssociation.unrestrict_primary_key
        association = QuotaAssociation.new(
            main_quota_definition_sid: parent_quota.quota_order_number_sid,
            sub_quota_definition_sid: sub_quota.quota_order_number_sid,
            relation_type: 'EQ',
            coefficient: coefficient,
        )
        settings_saver.assign_system_ops!(association)
        association.save
      end

    end
  end
end