class QuotaDefinitionValidator < TradeTariffBackend::Validator
  validation :QD1, "Quota order number id + start date must be unique.", on: %i[create update] do
    validates :uniqueness, of: %i[quota_order_number_id quota_order_number_sid validity_start_date]
  end

  validation :QD2, "The start date must be less than or equal to the end date", on: %i[create update] do |record|
    if record.validity_start_date.present? && record.validity_end_date.present?
      record.validity_start_date <= record.validity_end_date
    end
  end

  validation :QD3, "The quota order number must exist.",
    on: %i[create update],
    if: ->(record) { record.quota_order_number_id.present? } do |record|
      record.quota_order_number.present?
    end

  validation :QD4, "The monetary unit code must exist.",
    on: %i[create update],
    if: ->(record) { record.monetary_unit_code.present? } do |record|
      record.monetary_unit.present?
    end

  validation :QD5, "The measurement unit code must exist.",
    on: %i[create update],
    if: ->(record) { record.measurement_unit_code.present? } do |record|
      record.measurement_unit.present?
    end

  validation :QD6, "The measurement unit qualifier code must exist.",
    on: %i[create update],
    if: ->(record) { record.measurement_unit_qualifier_code.present? } do |record|
      record.measurement_unit_qualifier.present?
    end

  validation :QD7,
    %(The validity period of the quota definition must be spanned by one of the validity
      periods of the referenced quota order number.),
    on: %i[create update] do
      validates :validity_date_span, of: :quota_order_number
    end

  validation :QD8,
    %(The validity period of the monetary unit code must span the validity period of the quota definition.),
    on: %i[create update] do
      validates :validity_date_span, of: :monetary_unit
    end

  validation :QD9,
    %(The monetary unit code must always be the Euro ISO code (or Euc for quota defined prior to the Euro Definition).),
    if: ->(record) { record.monetary_unit_code.present? },
    on: %i[create update] do |record|
      %w[EUR EUC].include?(record.monetary_unit_code)
    end

  validation :QD10,
    %(The validity period of the measurement unit code must span the validity period of the quota definition.),
    on: %i[create update] do
      validates :validity_date_span, of: :measurement_unit
    end

  validation :QD11,
    %(The validity period of the measurement unit qualifier code must span the validity period of the quota definition.),
    on: %i[create update] do
      validates :validity_date_span, of: :measurement_unit_qualifier
    end
end
