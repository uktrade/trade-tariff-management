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
    allow_any_instance_of(WorkbasketValueObjects::AttributesParserBase).to receive(:regulation_description) { base_regulation.information_text }
    allow_any_instance_of(XmlGeneration::ExportWorker).to receive(:perform) { true }
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
      expect(page).to have_content('Quota created')
      expect(workbasket.reload.status).to eq('awaiting_approval')
      expect(page).to_not have_content("Cross-check next workbasket")
    end

    it 'allows rejecting' do
      visit root_path
      click_link 'Review for cross-check'
      select_reject_and_give_reason
      click_button('Finish cross-check')
      expect(page).to have_content('Quota cross-check rejected')
      expect(workbasket.reload.status).to eq('cross_check_rejected')
      expect(page).to_not have_content("Cross-check next workbasket")
    end

    context 'user has more workbaskets to cross check' do
      before(:example) do
        another_workbasket = create(:workbasket, user_id: other_user.id, title: '097456', type: :create_quota, status: :awaiting_cross_check)
        create(:quota_order_number, workbasket_id: another_workbasket.id)
        create(:quota_definition, :actual, quota_order_number_id: quota_order_number.id)
        another_measure = create(:measure, status: :awaiting_cross_check, workbasket_id: another_workbasket.id, measure_type: measure_type, geographical_area: geographical_area, quota_order_number: quota_order_number)
        another_workbasket.settings.measure_sids_jsonb = "[#{another_measure.measure_sid}]"
        another_workbasket.settings.save
      end

      it 'shows `Cross-check next workbasket` link' do
        visit root_path
        first(:link, 'Review for cross-check').click
        select_approve
        click_button('Finish cross-check')
        expect(page).to have_content('Quota created')
        expect(page).to have_content('Cross-check next workbasket')
        click_link 'Cross-check next workbasket'
        expect(page).to have_content('Cross-check and create quota')
      end
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
      expect(page).to_not have_content('Approve next workbasket')
    end

    it 'allows rejecting' do
      visit root_path
      click_link 'Review for approval'
      reject_approval
      expect(page).to have_content('Quota rejected')
      expect(workbasket.reload.status).to eq('approval_rejected')
      expect(page).to_not have_content('Approve next workbasket')
    end

    context 'user has more workbaskets to approve' do
      before(:example) do
        another_workbasket = create(:workbasket, user_id: other_user.id, title: '097456', type: :create_quota, status: :awaiting_approval)
        create(:quota_order_number, workbasket_id: another_workbasket.id)
        create(:quota_definition, :actual, quota_order_number_id: quota_order_number.id)
        another_measure = create(:measure, status: :awaiting_cross_check, workbasket_id: another_workbasket.id, measure_type: measure_type, geographical_area: geographical_area, quota_order_number: quota_order_number)
        another_workbasket.settings.measure_sids_jsonb = "[#{another_measure.measure_sid}]"
        another_workbasket.settings.save
      end

      it 'shows `Approve next workbasket` link' do
        visit root_path
        first(:link, 'Review for approval').click
        confirm_approval
        expect(page).to have_content('Quota approved')
        expect(page).to have_content('Approve next workbasket')
        click_link 'Approve next workbasket'
        expect(page).to have_content('Approve and create quota')
      end
    end
  end

  def select_approve
    find("label", text:'I confirm that I have checked the above details and am satisfied that they are correct.').click
  end

  def select_reject_and_give_reason
    find("label", text:'I am not satisfied with the above details.').click
    fill_in("Provide your reasons and/or state the changes required:", with: "Computer says no")
  end

  def confirm_approval
    find("label", text:'I confirm that I have checked the above details and am satisfied that they are correct.').click
    click_button 'Finish approval'
  end

  def reject_approval
    find("label", text:'I am not satisfied with the above details.').click
    fill_in("Provide your reasons and/or state the changes required:", with: "Computer says no")
    click_button 'Finish approval'
  end
end
