class GoodsNomenclatureValidator < TradeTariffBackend::Validator

  validation :NIG1, 'The validity period of the goods nomenclature must not overlap any other goods nomenclature with the same goods code' do |record|
    !GoodsNomenclature.where(
      goods_nomenclature_item_id: record.goods_nomenclature_item_id).where(
      producline_suffix: record.producline_suffix).where(
      Sequel.lit('validity_end_date >= ?', record.validity_start_date) | Sequel.lit('validity_end_date is null')).exclude(
      goods_nomenclature_sid: record.goods_nomenclature_sid).any?
  end

  validation :NIG4, 'The start date must be less than or equal to the end date.' do
    validates :validity_dates
  end

  validation :NIG11, 'At least one indent record is required and the start date of the first indentation must be equal to the start date of the nomenclature' do |record|
    indent = GoodsNomenclatureIndent.where(goods_nomenclature_sid: record.goods_nomenclature_sid).first
    indent.validity_start_date == record.validity_start_date
  end

end
