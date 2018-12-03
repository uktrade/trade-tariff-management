require "rails_helper"

RSpec.describe "approving a Create Measure workbasket", :js do
  it "allows cross-checked Measures to be approved" do
    create(:user)
    status = :awaiting_approval
    workbasket = create(:workbasket, status: status, type: "create_measures")
    create(:measure, status: status, workbasket_id: workbasket.id)

    visit new_approve_path(workbasket.id)

    select_radio("Approve the measures")
    input_date("Send to CDS", Date.current)
    click_on("Finish approval")

    expect(page).to have_content "Measures approved"
  end
end
