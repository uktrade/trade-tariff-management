class CertificateValidator < TradeTariffBackend::Validator
  validation :CE3, 'The start date must be less than or equal to the end date.', on: %i[create update] do
    validates :validity_dates
  end
end
