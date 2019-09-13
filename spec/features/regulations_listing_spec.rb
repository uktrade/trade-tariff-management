require 'rails_helper'

RSpec.describe "Regulations listing", :js do
  let!(:regulation_group) do
    group = create(:regulation_group)
    create(:regulation_group_description, regulation_group_id: group.regulation_group_id, description: "Various")

    group
  end

  let!(:regulation_role_type_description) do
    create(:regulation_role_type_description,
      regulation_role_type_id: 1,
      description: "Base regulation")
  end

  let!(:base_regulation) do
    create(:base_regulation, validity_start_date: 1.year.ago)
  end

  it "Find a regulation page" do
    visit(root_path)
    expect(page).to have_link("Find and edit regulations")

    click_link("Find and edit regulations")
    expect(page).to have_content("Find a regulation")

    expect(page).to have_content("Enter criteria to help locate a regulation")
    expect(page).to have_content("Select the regulation group")
    expect(page).to have_content("Start date from")
    expect(page).to have_content("End date to")
    expect(page).to have_content("Enter keyword(s)")
    expect(page).to have_content("If you know the ID of the regulation, then you can enter the ID in the box below. Alternatively, enter any other keyword(s) to help locate the regulation.")
  end

  it "Search params for a regulation" do
    visit(regulations_path)

    within("div.search_regulation_group_id") do
      search_for_value(type_value: "Various", select_value: "Various")
    end

    input_date_gds("#search_start_date", Date.today)
    input_date_gds("#search_end_date", Date.today + 2.days)

    fill_in("Enter keyword(s)", with: base_regulation.base_regulation_id)

    find(".form-actions .button").click

    sleep 1

    expect(page).to have_content(base_regulation.base_regulation_id)
  end
end
