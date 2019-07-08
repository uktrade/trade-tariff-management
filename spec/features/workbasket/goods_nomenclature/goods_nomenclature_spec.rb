require "rails_helper"

RSpec.describe "edit description" do


  let! (:chapter) { create(:chapter, goods_nomenclature_item_id: '1200000000')}
  let! (:commodity) { create(:commodity, :with_description, goods_nomenclature_item_id: '1234567890', indents: 4)}
  it "allows a description to be edited" do
    skip #not yet ready
    visit(new_manage_nomenclature_path(item_id: commodity.goods_nomenclature_item_id, suffix: commodity.producline_suffix))
    click_on("Cancel")


  end
end
