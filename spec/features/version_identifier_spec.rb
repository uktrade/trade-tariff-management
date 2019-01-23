require "rails_helper"

RSpec.describe "version identifier" do
  include EnvironmentHelper

  before { create(:user) }

  context "is available" do
    it "is displayed in the footer" do
      version_identifier = "772d3ac400befb2787516b93df42bc2ba73abf8d"

      with_environment("GIT_COMMIT" => version_identifier) do
        visit root_path
      end

      expect(find("footer")).to have_content "Version 772d3ac"
    end
  end

  context "isn't available" do
    it "isn't displayed in the footer" do
      with_environment("GIT_COMMIT" => nil) do
        visit root_path
      end

      expect(find("footer")).not_to have_content "Version"
    end
  end
end
