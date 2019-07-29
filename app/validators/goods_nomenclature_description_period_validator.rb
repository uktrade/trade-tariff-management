class GoodsNomenclatureDescriptionPeriodValidator < TradeTariffBackend::Validator

  validation :NIG12, 'No two associated description periods may have the same start date.' do
    validates :uniqueness, of: %i[goods_nomenclature_sid validity_start_date]
  end

  validation :NIG12, 'The start date must be less than or equal to the end date of the goods classification.',
    if: ->(record) { record.goods_nomenclature.validity_end_date.present? } do |record|
      (record.goods_nomenclature.validity_end_date >= record.validity_start_date)
    end

  validation :NIG12, 'The start date must be later than or equal to the start date of the goods classification.' do |record|
    (record.goods_nomenclature.validity_start_date <= record.validity_start_date)
  end

end
