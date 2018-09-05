require "rails_helper"

describe "Create Regulation", js: true do

  let!(:user)   { create :user, :gds_editor }

  # before do
  #   create(:user)
  # end

  # let(:user) do
  #   create(:user)
  # end

  it "follow create regulation page" do
    visit '/'
    expect(page).to have_content 'Create a regulation'
    click_link 'Create a regulation'
    expect(page).to have_content 'Specify the regulation type'
  end

end