class QuotaOrderNumberValidator < TradeTariffBackend::Validator

  #
  # TODO: We need to make sure and confirm code of this comformance rule
  #
  validation :QON1, 'Order number can not be blank.', on: [:create, :update] do
    validates :presence, of: :quota_order_number_id
  end

  validation :QON2, 'Order number must be unique.', on: [:create, :update] do
    validates :uniqueness, of: [:quota_order_number_id]
  end

  validation :QON3, "Order number should start with '09' and can contain digits only. Could be 6 length only.", on: [:create, :update] do |record|
    order_number_id = record.quota_order_number_id

    order_number_id.blank? || (
      order_number_id.present? &&
      (/^09(\d){4}\z/.match?(order_number_id))
    )
  end

end

