require 'rails_helper'

shared_examples_for 'regulation_page' do

  it 'open regulation page' do
    visit '/'
    expect(page).to have_content 'Create a regulation'

    click_link 'Create a regulation'
    expect(page).to have_content 'Specify the regulation type'
  end

end