require 'rails_helper'

RSpec.describe 'reassign workbasket', :js do
  include_context 'create_measures_base_context'

  let!(:approver_user) { create(:user, name: 'Approver user', approver_user: true) }
  let!(:tariff_manager) { create(:user, name: 'Tariff manager', approver_user: false) }
  let!(:other_user) { create(:user, name: 'Other user', approver_user: false) }

  let!(:workbasket) do
    create(:workbasket,
      user_id: other_user.id,
      title: '093456',
      type: :create_quota,
      status: :editing,)
  end



  context 'approver user' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(approver_user)
      allow_any_instance_of(ApplicationController).to receive(:token_expired?).and_return(false)
      allow_any_instance_of(ApplicationController).to receive(:audit_session).and_return(nil)
    end

    it 'shows reassign button on workbasket' do
      visit root_path
      expect(page).to have_content('Reassign')
    end

    it 'reassigns the workbasket to selected user' do
      visit root_path
      click_link 'Reassign'
      all(".multiple-choice").last.click

      reassigned_to = User.find(name: all(".multiple-choice").last.text)

      click_button 'Reassign'
      expect(page).to have_content('Workbasket reassigned')
      expect(workbasket.reload.user_id).to eq reassigned_to.id
    end
  end

  context 'non-approver user' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(other_user)
      allow_any_instance_of(ApplicationController).to receive(:token_expired?).and_return(false)
      allow_any_instance_of(ApplicationController).to receive(:audit_session).and_return(nil)
    end

    it 'shows reassign button' do
      visit root_path
      expect(page).to have_content('Reassign')
    end
  end
end
