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
    click_on "Manage"

    fill_in("What is the name of this workbasket?", with: "Test basket name")
    fill_in("What is the reason for these changes?", with: "Test edit nom reason")
    click_on("Continue")

    fill_in("Enter new description", with: "Shiny new description")
    fill_in("Day", with: "01")
    fill_in("Month", with: "01")
    fill_in("Year", with: "2030")
    click_on("Submit for approval")

    expect(page).to have_content("The workbasket Test basket name has been submitted for approval.")
  end

  it "displays correct descriptions when viewing at specific date" do
    future_commodity = create(:goods_nomenclature,
                              :with_description,
                              validity_start_date: Date.today + 6.months,
                              goods_nomenclature_item_id: '1234567890',
                              indents: 2,
                              description: "I am from the future")

    visit (root_path)
    click_on('Manage the goods classification')
    click_on chapter.section.title
    click_on chapter.description.capitalize
    click_on heading.description
    expect(page).to have_content("Nom nom description")

    find('#change_nomenclature_date').click
    select (1.year.from_now.year.to_s), :from => "nomenclature_date[year]"
    click_on('Set date')
    expect(page).to have_content("I am from the future")

    # Check date is not lost when browsing through links.
    click_on chapter.section.title
    click_on chapter.description.capitalize
    click_on heading.description
    expect(page).to have_content("I am from the future")

    find('#change_nomenclature_date').click
    select (Date.today.year.to_s), :from => "nomenclature_date[year]"
    click_on('Set date')
    expect(page).to_not have_content("I am from the future")
    expect(page).to have_content("Nom nom description")

  end
end
