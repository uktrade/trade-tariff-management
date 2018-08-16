class QuotaOrderNumberValidator < TradeTariffBackend::Validator

  #
  # TODO: We need to make sure and confirm code of this comformance rule
  #
  validation :QON1, 'Order number can not be blank.', on: [:create, :update] do
    validates :presence, of: :quota_order_number_id
  end
end

