require 'rails_helper'

describe 'base regulation', js: true do

  include_context 'create_regulation_base_context'

  it 'follow create regulation page' do
    visit_create_regulation

    custom_select('Base regulation', from: 'Specify the regulation type')
    click_on 'Create regulation'
    page.save_screenshot('screenshot.png')

    # fill_in 'Publication year', with: '18'
    # expect(page).to have_content 'Start date'
  end

end