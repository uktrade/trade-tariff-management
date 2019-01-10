class FootnoteDescriptionValidator < TradeTariffBackend::Validator
  #
  # TODO: We need to make sure and confirm code of this comformance rule
  #
  validation :FD1, "Description of footnote can not be blank.", on: %i[create update] do
    validates :presence, of: :description
  end
end
