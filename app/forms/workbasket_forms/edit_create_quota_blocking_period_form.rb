module WorkbasketForms
  class EditCreateQuotaBlockingPeriodForm
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ::WorkbasketHelpers::SettingsSaverHelperMethods

    attr_accessor :workbasket,
                  :workbasket_settings,
                  :settings_params,
                  :settings_errors,
                  :quota,
                  :description,
                  :quota_definition_sid,
                  :start_date,
                  :end_date

    BLOCKING_TYPES = {
      1 => '1. Block the allocations for a quota after its reopening due to a volume increase',
      2 => '2. Block the allocations for a quota after its reopening due to a volume increase',
      3 => '3. Block the allocations for a quota after its reopening due to the reception of quota return requests',
      4 => '4. Block the allocations for a quota due to the modification of the validity period after receiving quota return requests',
      5 => '5. Block the allocations for a quota on request of a MSA',
      6 => '6. Block the allocations for a quota due to an end-user decision',
      7 => '7. Block the allocations for a quota due to an exceptional condition',
      8 => '8 .Block the allocations for a quota after its reopening due to a balance transfer'
    }

    def initialize(workbasket_id, settings_params = {})
      @workbasket_settings = Workbaskets::CreateQuotaBlockingPeriodSettings.find(workbasket_id: workbasket_id)
      @workbasket = @workbasket_settings.workbasket
      @quota = QuotaOrderNumber.find(quota_order_number_id: @workbasket_settings.quota_order_number_id)
      @settings_params = settings_params
      @settings_errors = {}
    end

    def save
      @workbasket_settings.update(
        quota_definition_sid: @settings_params[:quota_definition_sid],
        description: @settings_params[:description],
        start_date: @settings_params[:start_date],
        end_date: @settings_params[:end_date],
        blocking_period_type: @settings_params[:blocking_period_type]
      )

      unless @workbasket_settings.quota_definition_sid
        @settings_errors[:quota_definition_sid] = "You must select a quota definition period"
      end

      if @workbasket_settings.start_date.empty?
        @settings_errors[:start_date] = "You must select a start date"
      end

      if @workbasket_settings.end_date.empty?
        @settings_errors[:end_date] = "You must select an end date"
      end

      if workbasket_settings.blocking_period_type.empty?
        @settings_errors[:blocking_period_type] = "You must select a blocking period type"
      end

      if all_fields_completed?
        unless start_date_valid?
          @settings_errors[:start_date_invalid] = 'You must select the date as on or after start date or before end date of the selected definition or blocking period'
        end

        if @workbasket_settings.description.length > 500
          @settings_errors[:description_too_long] = 'Description cannot be more than 500 characters'
        end
      end

      if @settings_errors.empty?
        QuotaBlockingPeriod.unrestrict_primary_key

        blocking_period = QuotaBlockingPeriod.new(
          quota_definition_sid: @workbasket_settings.quota_definition_sid,
          blocking_start_date: @workbasket_settings.start_date,
          blocking_end_date: @workbasket_settings.end_date,
          description: @workbasket_settings.description,
          blocking_period_type: @workbasket_settings.blocking_period_type,
          workbasket_id: @workbasket.id
        )

        if @settings_errors.empty?
          ::WorkbasketValueObjects::Shared::PrimaryKeyGenerator.new(blocking_period).assign!
          ::WorkbasketValueObjects::Shared::SystemOpsAssigner.new(
            blocking_period, system_ops
          ).assign!

          blocking_period.save

          workbasket.submit_for_cross_check!(current_admin: current_admin)
        end
      end

      @settings_errors.empty?
    end

    def system_ops
      {
        current_admin_id: current_admin.id,
        workbasket_id: workbasket.id,
        status: "awaiting_cross_check"
      }
    end

    def start_date_valid?
      definition = QuotaDefinition.find(quota_definition_sid: @workbasket_settings.quota_definition_sid)

      starts_same_day_or_after_definition?(definition) &&
       starts_before_end_day_of_definition?(definition) &&
        ends_after_start_date_of_definition(definition) &&
         ends_same_day_or_before_definition?(definition) &&
          ends_after_start_date?
    end

    def all_fields_completed?
      @workbasket_settings.quota_definition_sid && !@workbasket_settings.start_date.empty? && !@workbasket_settings.end_date.empty?
    end

    def starts_same_day_or_after_definition?(definition)
      definition.validity_start_date <= @workbasket_settings.start_date
    end

    def starts_before_end_day_of_definition?(definition)
      definition.validity_end_date > @workbasket_settings.start_date
    end

    def ends_after_start_date_of_definition(definition)
      definition.validity_start_date <= @workbasket_settings.end_date
    end

    def ends_same_day_or_before_definition?(definition)
      definition.validity_end_date >= @workbasket_settings.end_date
    end

    def ends_after_start_date?
      @workbasket_settings.start_date < @workbasket_settings.end_date
    end

    def blocking_reasons
      EditCreateQuotaBlockingPeriodForm::BLOCKING_TYPES
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
