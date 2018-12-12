class MeasureConditionComponentValidator < TradeTariffBackend::Validator
  validation :ME53, "The referenced measure condition must exist.", on: %i[create update] do |record|
    record.measure_condition_sid.present? && record.measure_condition.present?
  end

  validation :ME60, "The referenced monetary unit must exist.",
    on: %i[create update],
    if: ->(record) { record.monetary_unit_code.present? } do |record|
      record.monetary_unit.present?
    end

  validation :ME61, "The validity period of the referenced monetary unit must span the validity period of the measure.",
    on: %i[create update] do
    validates :validity_date_span, of: :monetary_unit
  end

  validation :ME62, "The combination measurement unit + measurement unit qualifier must exist.",
    on: %i[create update],
    if: ->(record) { record.measurement_unit_code.present? || record.measurement_unit_qualifier_code.present? } do |record|
    record.measurement_unit.present? && record.measurement_unit_qualifier.present?
  end

  validation :ME63, "The validity period of the measurement unit must span the validity period of the measure.",
  on: %i[create update] do
    validates :validity_date_span, of: :measurement_unit
  end

  validation :ME64, "The validity period of the measurement unit qualifier must span the validity period of the measure.",
    on: %i[create update] do
    validates :validity_date_span, of: :measurement_unit_qualifier
  end

  validation :ME105, "The reference duty expression must exist.", on: %i[create update] do |record|
    record.duty_expression_id.present? && record.duty_expression.present?
  end

  validation :ME106, "The VP of the duty expression must span the VP of the measure.", on: %i[create update] do
    validates :validity_date_span, of: :duty_expression
  end

  validation :ME108, "The same duty expression can only be used once within condition components of the same condition of the same measure. (i.e. it can be re-used in other conditions, no matter what condition type, of the same measure)", on: %i[create update] do
    validates :uniqueness, of: %i[measure_condition_sid duty_expression_id]
  end

  validation :ME109,
    %(If the flag 'amount' on duty expression is 'mandatory' then an amount must be specified.
    If the flag is set to 'not permitted' then no amount may be entered."),
    on: %i[create update] do |record|
      valid = true
      duty_expression = record.duty_expression

      if duty_expression&.duty_amount_applicability_code == 1
        valid = record.duty_amount.present?
      end

      if duty_expression&.duty_amount_applicability_code == 2
        valid = record.duty_amount.blank?
      end

      valid
    end

  validation :ME110,
    %(If the flag 'monetary unit' on duty expression is 'mandatory' then a monetary unit must be specified.
    If the flag is set to 'not permitted' then no monetary unit may be entered.),
    on: %i[create update] do |record|
      valid = true
      duty_expression = record.duty_expression

      if duty_expression&.monetary_unit_applicability_code == 1
        valid = record.monetary_unit_code.present?
      end

      if duty_expression&.monetary_unit_applicability_code == 2
        valid = record.monetary_unit_code.blank?
      end

      valid
    end

  validation :ME111,
    %(If the flag 'measurement unit' on duty expression is 'mandatory' then a measurement unit must be specified.
    If the flag is set to 'not permitted' then no measurement unit may be entered.),
    on: %i[create update] do |record|
      valid = true
      duty_expression = record.duty_expression

      if duty_expression&.measurement_unit_applicability_code == 1
        valid = record.measurement_unit_code.present?
      end

      if duty_expression&.measurement_unit_applicability_code == 2
        valid = record.measurement_unit_code.blank?
      end

      valid
    end
end
