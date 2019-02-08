require 'rails_helper'

describe "sso authorised spec", :js do

  # uses the user_factory which creates an enabled user
  let!(:user){ create(:user) }

  before(:each) do
    OmniAuth.config.add_mock(:developer, {:uid => 'uid-1',
                                          :info => {
                                              :first_name => 'mock',
                                              :last_name => 'user',
                                              :email => 'mock.user@mock.com'
                                          }})
  end

  it "allows authorised users to sign into application" do

    visit root_path
    sleep 5
    expect(page).to have_content "Sign out"

  end

end

describe "sso unauthorised spec", :js do

  before(:each) do
    # assign a user that shouldn't exist from any calls to the user_factory
    OmniAuth.config.add_mock(:developer, {:uid => 'uid-x666',
                                          :info => {
                                              :first_name => 'unknown',
                                              :last_name => 'mock-user',
                                              :email => 'unknown.mock.user@mock.com'
                                          }})
  end

  it "prevents unknown users from sign into application" do

    visit root_path
    sleep 5
    expect(page).to have_content "Unauthorised"

  end

end
