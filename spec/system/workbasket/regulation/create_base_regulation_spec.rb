require "rails_helper"

describe "Create Regulation", js: true do

  before do
    create(:regulation_role_type_description,
           regulation_role_type_id: 1, description: 'Base regulation')
    create(:regulation_role_type_description,
           regulation_role_type_id: 2, description: 'Provisional anti-dumping/countervailing duty')
    create(:regulation_role_type_description,
           regulation_role_type_id: 3, description: 'Definitive anti-dumping/countervailing duty')
    create(:regulation_role_type_description,
           regulation_role_type_id: 4, description: 'Modification')
    create(:regulation_role_type_description,
           regulation_role_type_id: 5, description: 'Prorogation')
    create(:regulation_role_type_description,
           regulation_role_type_id: 6, description: 'Complete abrogation')
    create(:regulation_role_type_description,
           regulation_role_type_id: 7, description: 'Explicit abrogation')
    create(:regulation_role_type_description,
           regulation_role_type_id: 8, description: 'Regulation which temporarily suspends all another regulation (FTS - Full Temporary Stop)')
  end

  let!(:user)   { create :user }

  it "follow create regulation page" do
    visit '/'
    expect(page).to have_content 'Create a regulation'

    click_link 'Create a regulation'
    expect(page).to have_content 'Specify the regulation type'

    custom_select('Base regulation', from: 'Specify the regulation type')
    fill_in 'Publication year', with: '18'

    expect(page).to have_content 'Start date'
  end

  after do

  end

end