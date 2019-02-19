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

  before(:example) do
    allow_any_instance_of(WorkbasketHelper).to receive(:workbasket_quota_periods_years_length) { 2 }
    allow_any_instance_of(WorkbasketValueObjects::AttributesParserBase).to receive(:measure_type) { MeasureType.first }
    allow_any_instance_of(WorkbasketValueObjects::AttributesParserBase).to receive(:regulation) { base_regulation.formatted_id }
    workbasket.settings.measure_sids_jsonb = "[#{measure.measure_sid}]"
    workbasket.settings.measure_sids_jsonb = "[#{measure.measure_sid}]"
    workbasket.settings.save
  end

  context 'cross check' do
    it 'allows approving' do
      visit root_path
      click_link 'Review for cross-check'
      select_approve
      click_button('Finish cross-check')
      expect(page).to have_content('Quota cross-checked.')
      expect(workbasket.reload.status).to eq('awaiting_approval')
    end

    it 'allows rejecting' do
      visit root_path
      click_link 'Review for cross-check'
      select_reject_and_give_reason
      click_button('Finish cross-check')
      expect(page).to have_content('Quota cross-check rejected')
      expect(workbasket.reload.status).to eq('cross_check_rejected')
    end
  end

  context 'approval' do
    let(:current_user) { User.first }

    before(:example) do
      workbasket.status = 'awaiting_approval'
      workbasket.save
      current_user.approver_user = true
      current_user.save
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user)
    end

    it 'allows confirming' do
      visit root_path
      click_link 'Review for approval'
      confirm_approval
      expect(page).to have_content('Quota approved')
      expect(workbasket.reload.status).to eq('awaiting_cds_upload_create_new')
    end

    it 'allows rejecting' do
      visit root_path
      click_link 'Review for approval'
      reject_approval
      expect(page).to have_content('Quota rejected')
      expect(workbasket.reload.status).to eq('approval_rejected')
    end
  end

  def select_approve
    find("[data-test='approve-cross-check']").click
  end

  def select_reject_and_give_reason
    find("[data-test='reject-cross-check']").click
    find("[data-test='reject-reason']").set('Something is wrong')
  end

  def confirm_approval
    find("[data-test='approve-approval']").click
    input_date('approve_export_date', Date.today)
    click_button 'Finish approval'
  end

  def reject_approval
    find("[data-test='reject-approval']").click
    fill_in('approve_reject_reasons', with: 'No no no no no')
    click_button 'Finish approval'
  end
end
