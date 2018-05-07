require 'rails_helper'

feature "Regulations listing" do
  let!(:user) do
    create(:user)
  end

  let!(:regulation_group) do
    group = create(:regulation_group)
    create(:regulation_group_description, regulation_group_id: group.regulation_group_id, description: "Various")

    group
  end

  let!(:base_regulation){ create(:base_regulation) }

  let!(:geographical_area) { create(:geographical_area) }

  scenario "Find a regulation page" do
    visit root_url
    expect(page).to have_link("Find a regulation")

    click_link("Find a regulation")
    expect(page).to have_content("Find a regulation")

    expect(page).to have_content("Enter criteria to help locate a regulation")
    expect(page).to have_content("Select the regulation group")
    expect(page).to have_content("Select date from")
    expect(page).to have_content("Select date to")
    expect(page).to have_content("Select a geographical area to which this regulation's measures apply")
    expect(page).to have_content("Enter keyword(s)")
    expect(page).to have_content("If you know the ID of the regulation, then you can enter the ID in the box below. Alternatively, enter any other keyword(s) to help locate the regulation.")
  end

  scenario "Search params for a regulation" do
    visit regulations_path
    expect(page).to have_content("Find a regulation")
    expect(page).not_to have_selector(".regulations-table")

    select("Various", from: "Select the regulation group")
    fill_in("Select date from", with: Date.today.strftime("%d/%m/%Y"))
    fill_in("Select date to", with: (Date.today + 2.days).strftime("%d/%m/%Y"))
    select(geographical_area.description, from: "Select a geographical area to which this regulation's measures apply")
    fill_in("Enter keyword(s)", with: "R901200")

    find(".form-actions .button").click

    expect(page).to have_selector(".regulations-table")
  end

  scenario "Regulations table" do
    visit regulations_path
    expect(page).to have_content("Find a regulation")
    expect(page).not_to have_selector(".regulations-table")

    find(".form-actions .button").click

    expect(page).to have_selector(".regulations-table")

    expect(page).to have_content("Legal base")
    expect(page).to have_content("Start date")
    expect(page).to have_content("End date")
    expect(page).to have_content("Publication date")
    expect(page).to have_content("Official Journal No.")
    expect(page).to have_content("Official Journal page")

    expect(page).to have_content(base_regulation.base_regulation_id)
    expect(page).to have_content(base_regulation.validity_start_date.strftime("%d/%m/%Y"))

    expect(find_all(".regulations-table tbody tr").length).to be > 0
  end
end
