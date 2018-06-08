class MeasureComponentValidator < TradeTariffBackend::Validator

  #
  # TODO: We need to make sure and confirm code of this comformance rule
  #
  validation :MC1, 'Duty expression id can not be blank.', on: [:create, :update] do
    validates :presence, of: :duty_expression_id
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
