class MeasureComponentValidator < TradeTariffBackend::Validator

  #
  # TODO: We need to make sure and confirm code of this comformance rule
  #
  validation :MC1, 'Duty expression id can not be blank.', on: [:create, :update] do
    validates :presence, of: :duty_expression_id
  end
end
