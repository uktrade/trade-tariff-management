class QuotaAssociationValidator < TradeTariffBackend::Validator

  validation :QA1, "The association between two quota definitions must be unique.",
    on: [:create, :update] do
    validates :uniqueness, of: [:main_quota_definition_sid, :sub_quota_definition_sid]
  end

  validation :QA2,
    %(The sub-quota’s validity period must be entirely enclosed within the validity
    period of the main quota),
    if: ->(record) { record.main_quota_definition.present? && record.sub_quota_definition.present? },
    on: [:create, :update] do |record|
      main_quota_definition = record.main_quota_definition
      sub_quota_definition = record.sub_quota_definition

      valid = main_quota_definition.validity_start_date <= sub_quota_definition.validity_start_date

      if valid
        valid = if main_quota_definition.validity_end_date.present? && sub_quota_definition.validity_end_date.present?
                  main_quota_definition.validity_end_date >= sub_quota_definition.validity_end_date
                elsif main_quota_definition.validity_end_date.nil? && sub_quota_definition.validity_end_date.nil?
                  true
                else
                  false
                end
      end

      valid
    end

end
