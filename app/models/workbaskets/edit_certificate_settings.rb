module Workbaskets
  class EditCertificateSettings < Sequel::Model(:edit_certificates_workbasket_settings)
    include ::WorkbasketHelpers::SettingsBase

    def collection_models
      %w(
        Certificate
        CertificateDescriptionPeriod
        CertificateDescription
      )
    end

    def settings
      JSON.parse(main_step_settings_jsonb)
    end

    def measure_sids_jsonb
      '{}'
    end
  end
end
