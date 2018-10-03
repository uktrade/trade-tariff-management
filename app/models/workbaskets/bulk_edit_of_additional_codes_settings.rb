module Workbaskets
  class BulkEditOfAdditionalCodesSettings < Sequel::Model(:bulk_edit_of_additional_codes_settings)

    include ::WorkbasketHelpers::SettingsBase

    def collection_models
      %w(
        AdditionalCode
        AdditionalCodeDescription
        AdditionalCodeDescriptionPeriod
        MeursingAdditionalCode
      )
    end

    def settings
      JSON.parse(main_step_settings_jsonb)
    end

    def set_workbasket_system_data!
      workbasket.update(
          title: main_step_settings['title'],
          operation_date: main_step_settings['start_date'].try(:to_date)
      )
    end

  end
end