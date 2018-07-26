class MeasureExcludedGeographicalAreaValidator < TradeTariffBackend::Validator

  #
  # TODO: We need to make sure and confirm code of this comformance rule
  #
  validation :MEGAV1, 'Excluded geographical area code can not be blank.', on: [:create, :update] do
    validates :presence, of: :excluded_geographical_area
  end
end

