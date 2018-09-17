class MeasureConditionComponentValidator < TradeTariffBackend::Validator

  validation :ME53, "The referenced measure condition must exist.", on: [:create, :update] do |record|
    record.measure_condition_sid.present? && record.measure_condition.present?
  end

  validation :ME60, "The referenced monetary unit must exist.",
    on: [:create, :update],
    if: ->(record) { record.monetary_unit_code.present? } do |record|
      record.monetary_unit.present?
    end

  validation :ME61, "The validity period of the referenced monetary unit must span the validity period of the measure.",
    on: [:create, :update] do
    validates :validity_date_span, of: :monetary_unit
  end

  validation :ME105, "The reference duty expression must exist.", on: [:create, :update] do |record|
    record.duty_expression_id.present? && record.duty_expression.present?
  end

  validation :ME106, "The VP of the duty expression must span the VP of the measure.", on: [:create, :update] do
    validates :validity_date_span, of: :duty_expression
  end

  validation :ME107, "If the short description of a duty expression starts with a '+' then a measure condition component with a preceding duty expression must exist (sequential ascending order) for a condition (at least one, not necessarily the same condition) of the same measure.",
    on: [:create, :update],
    if: ->(record) { record.measure_condition.present? } do |record|
      mccs = record.measure_condition.measure_condition_components
      last_mcc = mccs.last

      if mccs.size == 1
        last_mcc.duty_expression.present? && last_mcc.duty_expression.abbreviation.exclude?("+")
      else
        preceding_mccs = mccs[0..-2] # Removing last element

        # TODO: Need to refactor and use SQL query to achieve this.
        abbreviations = preceding_mccs.select{|mcc| mcc.duty_expression.present?}.map{ |mcc| mcc.duty_expression.abbreviation[0] }

        abbreviations.exclude?("+") && last_mcc.duty_expression.present? && last_mcc.duty_expression.abbreviation.include?("+")
      end
    end

  validation :ME108, "The same duty expression can only be used once within condition components of the same condition of the same measure. (i.e. it can be re-used in other conditions, no matter what condition type, of the same measure)", on: [:create, :update] do
    validates :uniqueness, of: [:measure_condition_sid, :duty_expression_id]
  end

  validation :ME109, "If the flag 'amount' on duty expression is 'mandatory' then an amount must be specified. If the flag is set to 'not permitted' then no amount may be entered.", on: [:create, :update] do |record|
    (record.duty_expression_id.present? && record.duty_expression.duty_amount_applicability_code == 1  && record.duty_amount.present?) ||
      (record.duty_expression_id.present? && record.duty_expression.duty_amount_applicability_code == 2  && record.duty_amount.blank?)
  end

  validation :ME110, "If the flag 'monetary unit' on duty expression is 'mandatory' then a monetary unit must be specified. If the flag is set to 'not permitted' then no monetary unit may be entered.", on: [:create, :update] do |record|
    (record.duty_expression_id.present? && record.duty_expression.monetary_unit_applicability_code == 1  && record.monetary_unit_code.present?) ||
      (record.duty_expression_id.present? && record.duty_expression.monetary_unit_applicability_code == 2  && record.monetary_unit_code.blank?)
  end

  validation :ME111, "If the flag 'measurement unit' on duty expression is 'mandatory' then a measurement unit must be specified. If the flag is set to 'not permitted' then no measurement unit may be entered.", on: [:create, :update] do |record|
    (record.duty_expression_id.present? && record.duty_expression.measurement_unit_applicability_code == 1  && record.measurement_unit_code.present?) ||
      (record.duty_expression_id.present? && record.duty_expression.measurement_unit_applicability_code == 2  && record.measurement_unit_code.blank?)
  end

end
