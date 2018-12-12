class MeasurePartialTemporaryStopValidator < TradeTariffBackend::Validator
  validation :ME74, "The start date of the PTS must be less than or equal to the end date.",
    on: %i[create update], if: ->(record) { record.validity_end_date.present? } do |record|
    record.validity_start_date <= record.validity_end_date
  end
end
