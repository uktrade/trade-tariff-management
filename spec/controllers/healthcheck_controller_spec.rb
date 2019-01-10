require 'rails_helper'

describe HealthcheckController, "GET #index" do
  it 'returns current release sha' do
    get :index

    expect(response.body).to match_json_expression(git_sha1: String)
  end
end
