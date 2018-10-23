module Quotas
  class StopSaver

    attr_accessor :current_admin,
                  :workbasket,
                  :workbasket_settings,
                  :status,
                  :operation_date

    def initialize(current_admin, workbasket, settings_ops={})
      @current_admin = current_admin
      @workbasket = workbasket
      @workbasket_settings = workbasket.settings
      @status = settings_ops[:status] || 'awaiting_cross_check'
      @operation_date = settings_ops[:operation_date] || workbasket_settings.configure_step_settings['start_date'].try(:to_date)
    end

    def valid?
      workbasket_settings.configure_step_settings['start_date'].present?
    end

    def persist!
      quota_definition_sids = QuotaDefinition.where(quota_order_number_id: workbasket_settings.quota_definition.quota_order_number_id).pluck(:quota_definition_sid).uniq
      parent_definition_sids = QuotaAssociation.where(sub_quota_definition_sid: quota_definition_sids, relation_type: 'NM').pluck(:main_quota_definition_sid).uniq
      sub_definition_sids = QuotaAssociation.where(main_quota_definition_sid: quota_definition_sids, relation_type: 'EQ').pluck(:sub_quota_definition_sid).uniq

      definition_sids = (quota_definition_sids + parent_definition_sids + sub_definition_sids).uniq
      quota_order_number_ids = []

      QuotaDefinition.where(quota_definition_sid: definition_sids).each do |definition|
        quota_order_number_ids << definition.quota_order_number_id
        if definition.validity_start_date <= operation_date
          if definition.validity_end_date.blank? || definition.validity_end_date > operation_date
            #end date current
            definition.measures.each do |measure|
              end_date_measure!(measure)
            end
            definition.validity_end_date = operation_date
            ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
                definition, system_ops.merge(operation: "U")
            ).assign!
            definition.save
          end
        else
          #delete all in future
          definition.measures.each do |measure|
            ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
                measure, system_ops.merge(operation: "D")
            ).assign!(false)
            measure.destroy
          end
          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
              definition, system_ops.merge(operation: "D")
          ).assign!(false)
          definition.destroy
        end
      end

      QuotaOrderNumber.where(quota_order_number_id: quota_order_number_ids.uniq).each do |order_number|
        if order_number.validity_start_date <= operation_date
          if order_number.validity_end_date.blank? || order_number.validity_end_date > operation_date
            order_number.validity_end_date = operation_date
            ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
                order_number, system_ops.merge(operation: "U")
            ).assign!
            order_number.save
          end
        else
          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
              order_number, system_ops.merge(operation: "D")
          ).assign!(false)
          order_number.destroy
        end
      end
    end

    def success_response
      {}
    end

    def error_response
      {}
    end

    private

    def system_ops
      {
          operation_date: operation_date,
          current_admin_id: current_admin.id,
          workbasket_id: workbasket.id,
          status: status
      }
    end

    def end_date_measure!(measure)
      measure.validity_end_date = operation_date

      measure.justification_regulation_id =
          workbasket_settings.configure_step_settings['regulation_id'] || measure.measure_generating_regulation_id
      measure.justification_regulation_role =
          workbasket_settings.configure_step_settings['regulation_role'] || measure.measure_generating_regulation_role

      ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
          measure, system_ops.merge(operation: "U")
      ).assign!

      measure.save
    end

  end
end
