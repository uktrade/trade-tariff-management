require "rails_helper"

RSpec.describe "edit description" do


  let! (:chapter) { create(:chapter, goods_nomenclature_item_id: '1200000000')}
  let! (:heading) { create(:heading, goods_nomenclature_item_id: '1234000000')}
  let! (:commodity) { create(:commodity, :with_description, goods_nomenclature_item_id: '1234567890', indents: 4)}
  it "allows a description to be edited" do
    visit(new_manage_nomenclature_path(item_id: commodity.goods_nomenclature_item_id, suffix: commodity.producline_suffix))
    fill_in("What is the name of this workbasket?", with: "Test basket name")
    fill_in("What is the reason for these changes?", with: "Test edit nom reason")
    click_on("Continue")

    fill_in("Enter new description", with: "Shiny new description")
    click_on("Submit for cross-check")

    expect(page).to have_content('Amended commodity code Shiny new description has been submitted for cross-check.')

  end
end
