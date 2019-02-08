require 'rails_helper'

describe "Find measures API: Users", type: :request do
  include_context "form_apis_base_context"

  let(:adam) do
    user.name = "Adam Sendler"
    user.email = "just_adam@example.com"
    user.save

    user.reload
  end

  let(:bredd) do
    create(:user, name: "Bredd Pit", email: "just_bred@example.com")
  end

  context "Index" do
    before do
      adam
      bredd
    end

    it "returns JSON collection of all actual users" do
      get "/users.json", headers: headers

      expect_user(0, adam)
      expect_user(1, bredd)
    end

    it "filters users by keyword" do
      get "/users.json", params: { q: "Adam Se" }, headers: headers

      expect(collection.count).to eq(1)
      expect_user(0, adam)

      get "/users.json", params: { q: "just_bred" }, headers: headers

      expect(collection.count).to eq(1)
      expect_user(0, bredd)
    end
  end

  private

  def expect_user(position, user)
    expect(collection[position]["id"]).to be_eql(user.id)
    expect(collection[position]["name"]).to be_eql(user.name)
  end
end
