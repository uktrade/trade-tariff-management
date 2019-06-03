require "rails_helper"

RSpec.describe "adding additional codes", :js do

  let (:code_type) { create(:additional_code_type) }
  let (:new_code) { '888' }
  let (:new_description) { 'New code description' }

  it "allows a new code to be created" do
    visit(root_path)
    click_on("Create new additional codes")

    fill_in("What is the name of this workbasket?", with: "workbasket description")
    input_date("When are these new codes valid from?", Date.today)
    within(first("div.additional-code-row")) do
      select_dropdown_value(code_type.additional_code_type_id)
    end
    fill_in('additional_code_code_0', with: new_code)
    fill_in('additional_code_description_0', with: new_description)

    click_on "Submit for cross-check"

    expect(page).to have_content "New additional codes submitted"

    expect(AdditionalCode.last).to have_attributes(additional_code_type_id: code_type.additional_code_type_id,
                                                   additional_code: new_code,
                                                   description: new_description)
  end
end
