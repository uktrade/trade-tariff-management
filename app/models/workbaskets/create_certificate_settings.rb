module Workbaskets
  class CreateCertificateSettings < Sequel::Model(:create_certificate_workbasket_settings)
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
  end
end
