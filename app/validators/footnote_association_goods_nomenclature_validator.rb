class FootnoteAssociationGoodsNomenclatureValidator < TradeTariffBackend::Validator

  #
  # FIXME: this need to be updated
  #
  # Issue 1: There are no FootnoteType with footnote_type_id = 'CN'
  #
  # Issue 2: Probably needs to be rewrited to reverse check:
  #
  #          !(CONDITION) instead of (CONDITION)
  #
  #          as currently it triggering for all GoodsNomneclatures which having
  #          goods_nomenclature_item_id.last(2) != "00"
  #
  # validation :ME71,
  #   %(Footnotes with a footnote type for which the application type = "CN footnotes"
  #   cannot be associated with TARIC codes (codes with pos. 9-10 different from 00)),
  #   on: [:create, :update] do |record|
  #     record.footnote_type == "CN" && record.goods_nomenclature_item_id.last(2) == "00"
  #   end
end
