require "rails_helper"

describe "base regulation", js: true do

  include_context 'create_regulation_base_context'

  it_behaves_like 'regulation_page'

  it 'follow create regulation page' do
    visit new_create_regulation_path

    custom_select('Base regulation', from: 'Specify the regulation type')
    fill_in 'Publication year', with: '18'

    expect(page).to have_content 'Start date'
  end

end