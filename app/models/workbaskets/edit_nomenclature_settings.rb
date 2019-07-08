module Workbaskets
  class EditNomenclatureSettings < Sequel::Model(:edit_nomenclature_workbasket_settings)
    include ::WorkbasketHelpers::SettingsBase

    def collection_models
      %w(
        GoodsNomenclature
        GoodsNomenclatureDescriptionPeriod
        GoodsNomenclatureDescription
        GoodsNomenclatureIndent
        GoodsNomenclatureOrigin
        GoodsNomenclatureSuccessor
        FootnoteAssociationGoodsNomenclature
      )
    end

    def settings
    end

    def measure_sids_jsonb
      '{}'
    end

  end
end
