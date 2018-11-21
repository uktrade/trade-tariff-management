require "rails_helper"

RSpec.describe "adding geographical areas", :js do
  it "allows a new group to be created" do
    _user = create(:user)

    visit(root_path)

    click_on("Create a new geographical area")

    select_radio("A group")
    fill_in("What code will identify this area?", with: "EU27")
    fill_in("What is the area description?", with: "A description")
    input_date("When is the area valid from?", 3.days.from_now)
    input_date("Specify the operation date", 3.days.from_now)

    click_on "Submit for cross-check"

    expect(page).to have_content "Geographical area submitted"
  end

  private

  def select_radio(label)
    find("label", text: label).click
  end

  def input_date(label, date)
    fill_in(label, with: date.strftime("%d/%m/%Y"))
    close_datepicker
  end

  def close_datepicker
    find("body").click
  end
end
