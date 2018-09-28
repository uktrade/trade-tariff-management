class QuotaDefinitionValidator < TradeTariffBackend::Validator

  validation :QD2, "The start date must be less than or equal to the end date" do |record|
    if record.validity_start_date.present? && record.validity_end_date.present?
      record.validity_start_date <= record.validity_end_date
    end
  end

end
