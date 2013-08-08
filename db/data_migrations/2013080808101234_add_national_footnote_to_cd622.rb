TradeTariffBackend::DataMigrator.migration do
  name "Add national footnote to Taric's CD662"

  FOOTNOTE_TYPE_ID = '06'
  FOOTNOTE_ID = '013'

  TARIC_FOOTNOTE_TYPE_ID = 'CD'
  TARIC_FOOTNOTE_ID = '662'

  ASSOCIATED_GOODS_CODES = %w[
    3818001011
    3818001019
    8541409021
    8541409029
    8541409031
    8541409039
  ]

  up do
    applicable {
      taric_footnote_count = FootnoteAssociationGoodsNomenclature.where(
        footnote_type: TARIC_FOOTNOTE_TYPE_ID,
        footnote_id: TARIC_FOOTNOTE_ID
      ).count

      chief_footnote_count = FootnoteAssociationGoodsNomenclature.where(
        footnote_type: FOOTNOTE_TYPE_ID,
        footnote_id: FOOTNOTE_ID
      ).count

      Footnote::Operation.where(footnote_type_id: FOOTNOTE_TYPE_ID, footnote_id: FOOTNOTE_ID).none? ||
      FootnoteDescription::Operation.where(footnote_type_id: FOOTNOTE_TYPE_ID, footnote_id: FOOTNOTE_ID).none? ||
      FootnoteDescriptionPeriod::Operation.where(footnote_type_id: FOOTNOTE_TYPE_ID, footnote_id: FOOTNOTE_ID).none? ||
      taric_footnote_count != chief_footnote_count
    }

    apply {
      # make the run idempotent, delete records first if they exist
      Footnote::Operation.where(footnote_type_id: FOOTNOTE_TYPE_ID, footnote_id: FOOTNOTE_ID).delete
      FootnoteDescription::Operation.where(footnote_type_id: FOOTNOTE_TYPE_ID, footnote_id: FOOTNOTE_ID).delete
      FootnoteDescriptionPeriod::Operation.where(footnote_type_id: FOOTNOTE_TYPE_ID, footnote_id: FOOTNOTE_ID).delete
      FootnoteAssociationGoodsNomenclature::Operation.where(footnote_type: FOOTNOTE_TYPE_ID, footnote_id: FOOTNOTE_ID).delete

      Footnote.new { |f|
        f.footnote_type_id = FOOTNOTE_TYPE_ID
        f.footnote_id = FOOTNOTE_ID
        f.national = true
        f.validity_start_date = Date.new(2013,8,6)
        f.operation_date = nil # as it came from initial import
      }.save

      FootnoteDescriptionPeriod.new { |fdp|
        fdp.footnote_description_period_sid = -217
        fdp.footnote_type_id = FOOTNOTE_TYPE_ID
        fdp.footnote_id = FOOTNOTE_ID
        fdp.validity_start_date = Date.new(2013,8,6)
        fdp.national = true
        fdp.operation_date = nil # as it came from initial import
      }.save

      FootnoteDescription.new { |fd|
        fd.footnote_description_period_sid = -217
        fd.language_id = 'EN'
        fd.footnote_type_id = FOOTNOTE_TYPE_ID
        fd.footnote_id = FOOTNOTE_ID
        fd.national = true
        fd.description = "Due to CHIEF being unable to process an additional code with two different duty rates, imports should be declared under the same numeric additional codes but replacing the 'A' with an 'X', to obtain exemption from the anti-dumping duty where the conditions under footnote CD662 are met."
        fd.operation_date = nil # as it came from initial import
      }.save

      FootnoteAssociationMeasure.where(
        footnote_type_id: TARIC_FOOTNOTE_TYPE_ID,
        footnote_id: TARIC_FOOTNOTE_ID
      ).join(
        :measures,
        { footnote_association_measures__measure_sid: :measures__measure_sid }
      ).where(
        measures__goods_nomenclature_item_id: ASSOCIATED_GOODS_CODES
      ).each { |measure_association|
        FootnoteAssociationMeasure.new { |fa_meas|
          fa_meas.measure_sid = measure_association.measure_sid
          fa_meas.footnote_type_id = FOOTNOTE_TYPE_ID
          fa_meas.footnote_id = FOOTNOTE_ID
          fa_meas.national = true
          fa_meas.operation_date = nil # as it came from initial import
        }.save
      }
    }
  end

  down do
    applicable {
      Footnote::Operation.where(footnote_type_id: FOOTNOTE_TYPE_ID, footnote_id: FOOTNOTE_ID).any? ||
      FootnoteDescription::Operation.where(footnote_type_id: FOOTNOTE_TYPE_ID, footnote_id: FOOTNOTE_ID).any? ||
      FootnoteDescriptionPeriod::Operation.where(footnote_type_id: FOOTNOTE_TYPE_ID, footnote_id: FOOTNOTE_ID).any? ||
      FootnoteAssociationGoodsNomenclature::Operation.where(footnote_type: FOOTNOTE_TYPE_ID, footnote_id: FOOTNOTE_ID).any?
    }

    apply {
      Footnote::Operation.where(footnote_type_id: FOOTNOTE_TYPE_ID, footnote_id: FOOTNOTE_ID).delete
      FootnoteDescription::Operation.where(footnote_type_id: FOOTNOTE_TYPE_ID, footnote_id: FOOTNOTE_ID).delete
      FootnoteDescriptionPeriod::Operation.where(footnote_type_id: FOOTNOTE_TYPE_ID, footnote_id: FOOTNOTE_ID).delete
      FootnoteAssociationGoodsNomenclature::Operation.where(footnote_type: FOOTNOTE_TYPE_ID, footnote_id: FOOTNOTE_ID).delete
    }
  end
end
