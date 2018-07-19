class MeasureConditionValidator < TradeTariffBackend::Validator

  #
  # TODO: We need to make sure and confirm code of this comformance rule
  #
  validation :MCD1, 'Condition code can not be blank.', on: [:create, :update] do
    validates :presence, of: :condition_code
  end
end
