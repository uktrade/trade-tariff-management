require "rails_helper"

describe "Create Regulation", js: true do

  let!(:user)   { create :user }

  it "follow create regulation page" do
    visit '/'
    expect(page).to have_content 'Create a regulation'
    click_link 'Create a regulation'
    expect(page).to have_content 'Specify the regulation type'
    within('.workbasket_forms_create_regulation_form_role') do
      find('.selectize-input', visible: false).click
      # page.should have_selector?('.dropdown-active')
    # print page.html
    # find(:css, "#workbasket_forms_create_regulation_form_role-selectized", visible: false).set('Base regulation')
    # find(:css, "#workbasket_forms_create_regulation_form_role-selectized", visible: false).native.send_keys(:return)
      # fill_in("#workbasket_forms_create_regulation_form_role-selectized", with: 'Base Regulation')
    end
    page.save_screenshot('screenshot.png')
    # expect(page).to have_content 'Start date'
  end

end