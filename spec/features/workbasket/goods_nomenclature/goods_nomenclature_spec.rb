require "rails_helper"

RSpec.describe "edit description" do


  let! (:chapter) { create(:chapter, :with_section, :with_description, goods_nomenclature_item_id: '1200000000', description: "Chapter description ABC")}
  let! (:heading) { create(:heading, :with_description, goods_nomenclature_item_id: '1234000000', description: "My heading description") }
  let! (:commodity) { create(:goods_nomenclature, :with_description, goods_nomenclature_item_id: '1234567890', indents: 2, description: "Nom nom description")}
  it "allows a description to be edited" do
    visit (root_path)
    click_on('Manage the goods classification')
    click_on chapter.section.title
    click_on chapter.description.capitalize
    click_on heading.description
    click_on "Manage"

    fill_in("What is the name of this workbasket?", with: "Test basket name")
    fill_in("What is the reason for these changes?", with: "Test edit nom reason")
    click_on("Continue")

    fill_in("Enter new description", with: "Shiny new description")
    click_on("Submit for cross-check")

    expect(page).to have_content("Amended commodity description 'Shiny new description' has been submitted for cross-check.")

  end
end
