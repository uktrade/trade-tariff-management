class QuotaAssociationValidator < TradeTariffBackend::Validator
  validation :QA1, "The association between two quota definitions must be unique.",
    on: %i[create update] do
    validates :uniqueness, of: %i[main_quota_definition_sid sub_quota_definition_sid]
  end

  validation :QA2,
    %(The sub-quota’s validity period must be entirely enclosed within the validity
    period of the main quota),
    on: %i[create update],
    if: ->(record) { record.main_quota_definition.present? && record.sub_quota_definition.present? } do |record|
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

  validation :QA3,
             %(When converted to the measurement unit of the main quota, the volume of a sub-quota must
             always be lower than or equal to the volume of the main quota.),
             on: %i[create update],
             if: ->(record) { record.main_quota_definition.present? && record.sub_quota_definition.present? } do |record|
               valid = true

               if record.main_quota_definition.measurement_unit_code.present? &&
                   record.main_quota_definition.measurement_unit.present?

                 valid = record.main_quota_definition.volume >= record.sub_quota_definition.volume
               end

               valid
             end

  # validation :QA4,
  #            %(Whenever a sub-quota receives a coefficient, this has to be a strictly positive decimal number.
  #            When it is not specified a value of 1 is always assumed),
  #            on: [:create, :update] do
  #              # NOT CLEAR
  #            end


  # validation :QA5,
  #            %(Whenever a sub-quota is defined with the ‘equivalent’ type, it must have the same volume
  #            as the ones associated with the parent quota. Moreover it must be defined with a coefficient
  #            not equal to 1),
  #            on: [:create, :update] do
  #              # NOT CLEAR
  #            end

  # validation :QA6,
  #            %(Sub-quotas associated with the same main quota must have the same relation type),
  #            on: [:create, :update] do
  #              # NOT CLEAR
  #            end
end
