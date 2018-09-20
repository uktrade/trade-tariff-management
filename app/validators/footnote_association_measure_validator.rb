class FootnoteAssociationMeasureValidator < TradeTariffBackend::Validator
  validation :ME69, "The associated footnote must exist." do |record|
    if record.footnote_type_id.present? || record.footnote_id.present?
      record.footnote.present?
    end
  end
end
