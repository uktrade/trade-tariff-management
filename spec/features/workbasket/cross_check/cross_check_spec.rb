require 'rails_helper'

RSpec.describe 'cross check', :js do
  include_context 'create_measures_base_context'

  let!(:workbasket) do
    create(:workbasket,
      user_id: other_user.id,
      title: '093456',
      type: :create_quota,
      status: :awaiting_cross_check,)
    end
  let!(:quota_order_number) { create(:quota_order_number, workbasket_id: workbasket.id) }
  let!(:quota_definition) { create(:quota_definition, :actual, quota_order_number_id: quota_order_number.id)}
  let!(:other_user) { create(:user, name: 'Other user') }

  let!(:measure) { create(:measure, status: :awaiting_cross_check, workbasket_id: workbasket.id, measure_type: measure_type, geographical_area: geographical_area, quota_order_number: quota_order_number) }


  it 'allows approving cross check' do
    allow_any_instance_of(WorkbasketHelper).to receive(:workbasket_quota_periods_years_length) { 2 }
    allow_any_instance_of(WorkbasketValueObjects::AttributesParserBase).to receive(:measure_type) { MeasureType.first }
    allow_any_instance_of(WorkbasketValueObjects::AttributesParserBase).to receive(:regulation) { base_regulation.formatted_id }
    workbasket.settings.measure_sids_jsonb = "[#{measure.measure_sid}]"
    workbasket.settings.measure_sids_jsonb = "[#{measure.measure_sid}]"
    workbasket.settings.save
    visit root_path
    click_link 'Review for cross-check'
    find("[data-test='approve-cross-check']").click
    click_button('Finish cross-check')
    expect(page).to have_content('Quota cross-checked.')
  end

  it 'allows approving cross check' do
    allow_any_instance_of(WorkbasketHelper).to receive(:workbasket_quota_periods_years_length) { 2 }
    allow_any_instance_of(WorkbasketValueObjects::AttributesParserBase).to receive(:measure_type) { MeasureType.first }
    allow_any_instance_of(WorkbasketValueObjects::AttributesParserBase).to receive(:regulation) { base_regulation.formatted_id }
    workbasket.settings.measure_sids_jsonb = "[#{measure.measure_sid}]"
    workbasket.settings.measure_sids_jsonb = "[#{measure.measure_sid}]"
    workbasket.settings.save
    visit root_path
    click_link 'Review for cross-check'
    find("[data-test='reject-cross-check']").click
    find("[data-test='reject-reason']").set('xxxxx')
    click_button('Finish cross-check')
    expect(page).to have_content('Quota cross-check rejected')
  end
end
