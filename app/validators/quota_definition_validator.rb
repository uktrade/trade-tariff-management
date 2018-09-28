class QuotaDefinitionValidator < TradeTariffBackend::Validator

  validation :QD1, "Quota order number id + start date must be unique.", on: [:create, :update] do
    validates :uniqueness, of: [:quota_order_number_id, :quota_order_number_sid, :validity_start_date]
  end

  validation :QD2, "The start date must be less than or equal to the end date", on: [:create, :update] do |record|
    if record.validity_start_date.present? && record.validity_end_date.present?
      record.validity_start_date <= record.validity_end_date
    end
  end

end
