class FootnoteAssociationMeasureValidator < TradeTariffBackend::Validator
  validation :ME69, "The associated footnote must exist." do |record|
    if record.footnote_type_id.present? || record.footnote_id.present?
      record.footnote.present?
    end
  end

  validation :ME70, "The same footnote can only be associated once with the same measure.",
    on: [:create, :update] do |record|

    existing_list = FootnoteAssociationMeasure.where(
      measure_sid: record.measure_sid,
      footnote_type_id: record.footnote_type_id,
      footnote_id: record.footnote_id,
    )

    existing_list = existing_list.where("oid != ?", record.oid) if record.oid.present?

    existing_list.empty?
  end

  #
  # FIXME: need to fix it on Edit footnote functionality
  #
  # validation :ME73,
  #   %(The validity period of the associated footnote must span the validity period of the measure.),
  #   on: [:create, :update] do
  #     validates :validity_date_span, of: :measure
  #   end
end
