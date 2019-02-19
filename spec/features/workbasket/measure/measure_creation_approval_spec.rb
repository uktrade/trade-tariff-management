require "rails_helper"

RSpec.describe "approval process for a Create Measure workbasket", :js do
  include_context 'create_measures_base_context'

  it "allows a Measure to be cross-checked" do
    workbasket = workbasket_creating_measure(status: :awaiting_cross_check)

    visit new_cross_check_path(workbasket.id)
    select_radio(/I confirm that I have checked the above details?/i)
    click_on("Finish cross-check")

    expect(page).to have_content "Measures cross-checked"
  end

  it "allows a user to reject during cross-check" do
    workbasket = workbasket_creating_measure(status: :awaiting_cross_check)

    visit new_cross_check_path(workbasket.id)
    select_radio('I am not happy.')
    click_on("Finish cross-check")

    message = page.find("#rejection_reason").native.attribute("validationMessage")
    expect(message).to eq "Please fill in this field."

    fill_in("Provide your reasons", with: "Computer says no")
    click_on("Finish cross-check")

    expect(page).to have_content "Measures cross-check rejected"
  end


  it "allows a cross-checked Measure to be approved" do
    workbasket = workbasket_creating_measure(status: :awaiting_approval)

    visit new_approve_path(workbasket.id)
    find("label", text:'Approve.').click
    click_on("Finish approval")

    expect(page).to have_content "Measures approved"
  end

  it "allows a cross-checked Measure to be rejected" do
    workbasket = workbasket_creating_measure(status: :awaiting_approval)

    visit new_approve_path(workbasket.id)

    find("label", text:'I am not happy.').click
    click_on("Finish approval")

    message = page.find("#approve_reject_reasons").native.attribute("validationMessage")
    expect(message).to eq "Please fill in this field."

    fill_in("Provide your reasons and/or state the changes required:", with: "Computer says no")
    click_on("Finish approval")

    expect(page).to have_content "Measures rejected"
  end

  private

  def workbasket_creating_measure(status:)
    workbasket = create(:workbasket, status: status, type: "create_measures")
    create(:measure, status: status, workbasket_id: workbasket.id, measure_type: measure_type, geographical_area: geographical_area)
    settings_params = { regulation_id: base_regulation.base_regulation_id, measure_type_id: '277', measure_type: measure_type, geographical_area_id: geographical_area.geographical_area_id}
    ::WorkbasketInteractions::CreateMeasures::SettingsSaver.new(workbasket, "main", "continue", settings_params).save!
    workbasket
  end
end
