class QuotaOrderNumberOriginExclusionValidator < TradeTariffBackend::Validator
  #
  # TODO: We need to make sure and confirm code of this comformance rule
  #
  validation :QONOE1, 'Order number can not be blank.', on: %i[create update] do
    validates :presence, of: :quota_order_number_origin_sid
  end

  validation :QONOE2, 'Excluded geographical area can not be blank.', on: %i[create update] do
    validates :presence, of: :excluded_geographical_area_sid
  end
end
