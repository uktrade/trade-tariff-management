require "rails_helper"

RSpec.describe "edit additional codes", :js do
  it 'updates existing additional code' do
    create(:additional_code_type, additional_code_type_id: 'A')

    additional_code_1 = create(:additional_code,
                               additional_code_type_id: 'A',
                               additional_code: '888',
                               status: 'published')
    description_1 = 'Description for 1st Code'
    additional_code_description_1 = create(:additional_code_description, :with_period,
                                           additional_code_sid: additional_code_1.additional_code_sid,
                                           additional_code_type_id: additional_code_1.additional_code_type_id,
                                           additional_code: additional_code_1.additional_code,
                                           description: description_1,
                                           valid_at: 2.years.ago,
                                           valid_to: nil)

   visit(root_path)
   click_on("Find and edit additional codes")

   fill_in("search[code][value]", with: "888")
   click_on "Search"
   expect(page).to have_content "1 additional code found"
   click_on 'Work with selected codes'
   fill_in(:reason, with: 'blah blah')
   fill_in(:title, with: 'blah blah')
   click_on 'Proceed to selected codes'
   find('#bulk-action-dropdown').click
   click_link 'Change validity period'
   find('#additional-codes-end-date').set("02/01/2030")
   find('#additional-codes-start-date').set("01/01/2030")
   click_on 'Update selected codes'
   click_on 'Submit changes for cross-check'
   expect(page).to have_content 'Additional codes submitted'

   expect(AdditionalCode.count).to eq 1
   expect(AdditionalCode.first.validity_start_date.strftime('%m/%d/%Y')).to eq "01/01/2030"
   expect(AdditionalCode.first.validity_end_date.strftime('%m/%d/%Y')).to eq "02/01/2030"
  end
end
