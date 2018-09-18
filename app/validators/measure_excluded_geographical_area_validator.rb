class MeasureExcludedGeographicalAreaValidator < TradeTariffBackend::Validator

  #
  # TODO: We need to make sure and confirm code of this comformance rule
  #
  validation :MEGAV1, 'Excluded geographical area code can not be blank.', on: [:create, :update] do
    validates :presence, of: :excluded_geographical_area
  end

  validation :ME65, "An exclusion can only be entered if the measure is applicable to a geographical area group (area code = 1).",
    on: [:create, :update] do |record|
    record.measure.geographical_area.geographical_code == "1"
  end

  validation :ME66, "The excluded geographical area must be a member of the geographical area group.",
    on: [:create, :update],
    if: ->(record) { record.excluded_geographical_area.present? } do |record|
      record.excluded_geographical_area == record.geographical_area.try(:geographical_area_id)
    end
end

