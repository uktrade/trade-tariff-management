class QuotaAssociationValidator < TradeTariffBackend::Validator

  validation :QA1, "The association between two quota definitions must be unique." do
    validates :uniqueness, of: [:main_quota_definition_sid, :sub_quota_definition_sid]
  end

end
