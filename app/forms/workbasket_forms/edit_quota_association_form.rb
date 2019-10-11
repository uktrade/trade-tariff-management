module WorkbasketForms
  class EditQuotaAssociationForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ::WorkbasketHelpers::SettingsSaverHelperMethods

    attr_accessor :workbasket,
                  :workbasket_settings,
                  :settings_params,
                  :settings_errors,
                  :parent_quota,
                  :child_quota,
                  :selected_parent_definition_period,
                  :selected_child_definition_period

    def initialize(workbasket_id, settings_params = {})
      @workbasket_settings = Workbaskets::CreateQuotaAssociationSettings.find(workbasket_id: workbasket_id)
      @workbasket = @workbasket_settings.workbasket
      @parent_quota = QuotaOrderNumber.find(quota_order_number_id: @workbasket_settings.parent_quota_order_id)
      @child_quota = QuotaOrderNumber.find(quota_order_number_id: @workbasket_settings.child_quota_order_id)
      @settings_params = settings_params
      @settings_errors = {}
    end

    def save
      @workbasket_settings.update(
        parent_quota_definition_period: @settings_params[:parent_definition_period],
        child_quota_definition_period: @settings_params[:child_definition_period],
        relation_type: @settings_params[:relation_type],
        coefficient: format_coefficient(@settings_params[:coefficient])
      )

      if @settings_params[:parent_definition_period].blank?
        @settings_errors[:parent_definition_period] = "Parent definition period must be selected"
      end

      if @settings_params[:child_definition_period].blank?
        @settings_errors[:child_definition_period] = "Child definition period must be selected"
      end

      if @settings_params[:relation_type].blank?
        @settings_errors[:relation_type] = "Relation type must be selected"
      end

      if @settings_params[:coefficient].blank?
        @settings_errors[:coefficient] = "Co-efficient must be entered"
      elsif !is_number?(@settings_params[:coefficient])
        @settings_errors[:coefficient] = "Co-efficient must be numeric"
      end

      if @settings_errors.empty?
        QuotaAssociation.unrestrict_primary_key
        association = QuotaAssociation.new(
          main_quota_definition_sid: @workbasket_settings.parent_quota_definition_period,
          sub_quota_definition_sid: @workbasket_settings.child_quota_definition_period,
          relation_type: @workbasket_settings.relation_type,
          coefficient: @workbasket_settings.coefficient
          )

        ::WorkbasketValueObjects::Shared::ConformanceErrorsParser.new(
          association, QuotaAssociationValidator, {}
        ).errors.map do |key, error|
          @settings_errors.merge!("general": error.join('. '))
        end

        if @settings_errors.empty?
          assign_system_ops!(association)
          association.save
          workbasket.submit_for_cross_check!(current_admin: current_admin)
        end
      end

      @settings_errors.empty?
    end

    private def is_number?(string)
      true if Float(string) rescue false
    end

    private def format_coefficient(coefficient)
      # Always has 5 decimal places
      '%.5f' % coefficient.to_f.truncate(5)
    end
  end
end
