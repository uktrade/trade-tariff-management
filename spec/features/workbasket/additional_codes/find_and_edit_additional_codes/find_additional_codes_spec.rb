require "rails_helper"

RSpec.describe "find additional codes", :js do

  # let (:code_type) { create(:additional_code_type) }
  # let (:new_code) { '888' }
  # let (:new_description) { 'New code description' }
  #
  it "finds the correct codes" do
    create(:additional_code_type, additional_code_type_id: 'A')
    create(:additional_code_type, additional_code_type_id: 'B')

    additional_code_1 = create(:additional_code,
                               additional_code_type_id: 'A',
                               additional_code: '888')
    description_1 = 'Description for 1st Code'
    additional_code_description_1 = create(:additional_code_description, :with_period,
                                           additional_code_sid: additional_code_1.additional_code_sid,
                                           additional_code_type_id: additional_code_1.additional_code_type_id,
                                           additional_code: additional_code_1.additional_code,
                                           description: description_1,
                                           valid_at: 2.years.ago,
                                           valid_to: nil)

    additional_code_2 = create(:additional_code,
                               additional_code_type_id: 'A',
                               additional_code: '777')
    additional_code_description_2 = create(:additional_code_description, :with_period,
                                           additional_code_sid: additional_code_2.additional_code_sid,
                                           additional_code_type_id: additional_code_2.additional_code_type_id,
                                           additional_code: additional_code_2.additional_code,
                                           description: 'Description for 2nd Code',
                                           valid_at: 2.years.ago,
                                           valid_to: nil)

    additional_code_3 = create(:additional_code,
                               additional_code_type_id: 'B',
                               additional_code: '888')
    description_3 = '3rd Description'
    additional_code_description_3 = create(:additional_code_description, :with_period,
                                           additional_code_sid: additional_code_3.additional_code_sid,
                                           additional_code_type_id: additional_code_3.additional_code_type_id,
                                           additional_code: additional_code_3.additional_code,
                                           description: description_3,
                                           valid_at: 2.years.ago,
                                           valid_to: nil)

    visit(root_path)
    click_on("Find and edit additional codes")

    fill_in("search[code][value]", with: "888")
    click_on "Search"

    expect(page).to have_content "2 additional codes found"
    descriptions = page.all('.description-column')
    expect(descriptions[1].text).to eq(description_1)
    expect(descriptions[2].text).to eq(description_3)

    # Check sorting
    find("a", :text => "Description").click
    descriptions = page.all('.description-column')
    expect(descriptions[1].text).to eq(description_3)
    expect(descriptions[2].text).to eq(description_1)
  end
end
