class QuotaOrderNumberOriginValidator < TradeTariffBackend::Validator

  #
  # TODO: We need to make sure and confirm code of this comformance rule
  #
  validation :QONO1, 'Order number can not be blank.', on: [:create, :update] do
    validates :presence, of: :quota_order_number_sid
  end

  validation :QONO2, 'Geographical area can not be blank.', on: [:create, :update] do
    validates :presence, of: :geographical_area_id
  end
end

