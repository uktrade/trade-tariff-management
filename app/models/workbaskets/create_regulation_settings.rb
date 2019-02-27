module Workbaskets
  class CreateRegulationSettings < Sequel::Model(:create_regulation_workbasket_settings)
    include ::WorkbasketHelpers::SettingsBase

    def collection_models
      %w(
        BaseRegulation
        ModificationRegulation
        ProrogationRegulation
        CompleteAbrogationRegulation
        ExplicitAbrogationRegulation
        FullTemporaryStopRegulation
      )
    end

    def regulation
      collection.first
    end

    def pdf_document
      nil
    end

    def settings
      JSON.parse(main_step_settings_jsonb)
    end

    def measure_sids_jsonb
      '{}'
    end
  end
end
