class MeasureConditionValidator < TradeTariffBackend::Validator
  #
  # TODO: We need to make sure and confirm code of this comformance rule
  #
  validation :MCD1, 'Condition code can not be blank.', on: %i[create update] do
    validates :presence, of: :condition_code
  end

  validation :ME56, "The referenced certificate must exist.",
    on: %i[create update],
    if: ->(record) { record.certificate_type_code.present? || record.certificate_code.present? } do |record|
      record.certificate.present?
    end

  validation :ME57, "The validity period of the referenced certificate must span the validity period of the measure.",
    on: %i[create update] do
    validates :validity_date_span, of: :certificate
  end

  validation :ME58, "The same certificate can only be referenced once by the same measure and the same condition type.",
    on: %i[create update] do
    validates :uniqueness, of: %i[measure_sid certificate_type_code certificate_code]
  end

  validation :ME59, "The referenced action code must exist.",
    on: %i[create update],
    if: ->(record) { record.action_code.present? } do |record|
    record.measure_action.present?
  end
end
