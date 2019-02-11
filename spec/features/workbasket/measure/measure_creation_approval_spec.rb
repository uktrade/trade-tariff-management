require "rails_helper"

RSpec.describe "approval process for a Create Measure workbasket", :js do
  it "allows a cross-checked Measure to be approved" do
    workbasket = workbasket_creating_measure(status: :awaiting_approval)

    visit new_approve_path(workbasket.id)

    select_radio("Approve the measures")
    input_date("Send to CDS", Date.current)
    click_on("Finish approval")

    expect(page).to have_content "Measures approved"
    expect(workbasket.reload.operation_date&.to_date).to eq Date.current
  end

  it "allows a cross-checked Measure to be rejected" do
    workbasket = workbasket_creating_measure(status: :awaiting_approval)

    visit new_approve_path(workbasket.id)

    select_radio("I am not happy with the measure")
    fill_in("Provide your reasons", with: "Computer says no")
    click_on("Finish approval")

    expect(page).to have_content "Measures rejected"
  end

  private

  def workbasket_creating_measure(status:)
    workbasket = create(:workbasket, status: status, type: "create_measures")
    create(:measure, status: status, workbasket_id: workbasket.id)
    workbasket
  end
end
