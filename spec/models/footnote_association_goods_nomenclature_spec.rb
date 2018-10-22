require "rails_helper"

describe FootnoteAssociationGoodsNomenclature do
  #
  # FIXME: need to update logic of this validation
  #
  # describe "validations" do
  #   describe "conformance rules" do
  #     describe "ME71: Footnotes with a footnote type for which the application type = 'CN footnotes' cannot be associated with TARIC codes (codes with pos. 9-10 different from 00)" do
  #       it "shoud run validation succesfully" do
  #         footnote_association_goods_nomenclature = FootnoteAssociationGoodsNomenclature.new
  #         footnote_association_goods_nomenclature.goods_nomenclature_item_id = "3826009000"
  #         footnote_association_goods_nomenclature.footnote_type = "CN"

  #         expect(footnote_association_goods_nomenclature).to be_conformant
  #       end

  #       it "shoud not run validation succesfully" do
  #         footnote_association_goods_nomenclature = FootnoteAssociationGoodsNomenclature.new
  #         footnote_association_goods_nomenclature.goods_nomenclature_item_id = "3826009090"
  #         footnote_association_goods_nomenclature.footnote_type = "CN"

  #         expect(footnote_association_goods_nomenclature).to_not be_conformant
  #         expect(footnote_association_goods_nomenclature.conformance_errors).to have_key(:ME71)

  #         footnote_association_goods_nomenclature.goods_nomenclature_item_id = "3826009000"
  #         footnote_association_goods_nomenclature.footnote_type = "JT"

  #         expect(footnote_association_goods_nomenclature).to_not be_conformant
  #         expect(footnote_association_goods_nomenclature.conformance_errors).to have_key(:ME71)
  #       end
  #     end
  #   end
  # end
end
