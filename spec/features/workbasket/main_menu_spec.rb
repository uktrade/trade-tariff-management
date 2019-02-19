require 'rails_helper'

describe 'workbasket table', js: true do
  context 'no workbaskets exist' do
    it 'contains no data' do
      visit root_path
      expect(page).to have_content('You are not working with any items at the moment.')
    end
  end

  context 'user has created a workbasket' do
    let!(:current_users_workbasket) do
      create(:workbasket,
             user_id: User.first.id,
             title: '093456',
             type: :create_measures,
             status: :new_in_progress,)
    end

    it 'displays user workbasket data' do
      visit root_path

      expect(page).to have_content(current_users_workbasket.title)
      expect(page).to have_content('Create Measure')
      expect(page).to have_content('New - in progress')
      expect(page).to have_content(Date.today.strftime('%d %b %Y'))
      expect(page).to have_content('Continue')
    end

    context "user's `create measure` workbasket has been submitted for cross checker" do
      it 'shows status `Awaiting cross-check` and option to withdraw or edit' do
        current_users_workbasket.status = :awaiting_cross_check
        current_users_workbasket.save
        visit root_path
        expect(page).to have_content(current_users_workbasket.title)
        expect(page).to have_content('Create Measure')
        expect(page).to have_content('Awaiting cross-check')
        expect(page).to have_content('Withdraw/edit')
      end
    end

    context "user's `create measure` workbasket has been rejected by cross checker" do
      it 'shows workbasket with status `Cross-check rejected`' do
        current_users_workbasket.status = :cross_check_rejected
        current_users_workbasket.save
        visit root_path
        expect(page).to have_content(current_users_workbasket.title)
        expect(page).to have_content('Create Measure')
        expect(page).to have_content('Cross-check rejected')
        expect(page).to have_content('Withdraw/edit')
      end
    end

    context "user's `create quota` workbasket has been submitted for cross checker" do
      it 'shows status `Awaiting cross-check` and option to withdraw or edit' do
        current_users_workbasket.type = :create_quota
        current_users_workbasket.status = :awaiting_cross_check
        current_users_workbasket.save
        visit root_path
        expect(page).to have_content(current_users_workbasket.title)
        expect(page).to have_content('Create Quota')
        expect(page).to have_content('Awaiting cross-check')
        expect(page).to have_content('Withdraw/edit')
      end
    end

    context "user's `create quota` workbasket has been rejected by cross checker" do
      it 'shows workbasket with status `Cross-check rejected`' do
        current_users_workbasket.type = :create_quota
        current_users_workbasket.status = :cross_check_rejected
        current_users_workbasket.save
        visit root_path
        expect(page).to have_content(current_users_workbasket.title)
        expect(page).to have_content('Create Quota')
        expect(page).to have_content('Cross-check rejected')
        expect(page).to have_content('Withdraw/edit')
      end
    end

    context 'another user has created a workbasket which is awaiting cross check' do
      let!(:another_user) do
        create(:user)
      end

      let!(:other_users_awaiting_cross_check_workbasket) do
        create(:workbasket,
               user_id: another_user.id,
               title: '091234',
               type: :create_quota,
               status: :awaiting_cross_check,)
      end

      it 'displays other users workbasket data' do
        visit root_path
        expect(page).to have_content(current_users_workbasket.title)
        expect(page).to have_content('Create Measure')
        expect(page).to have_content('New - in progress')
        expect(page).to have_content(Date.today.strftime('%d %b %Y'))
        expect(page).to have_content('Continue')

        expect(page).to have_content(other_users_awaiting_cross_check_workbasket.title)
        expect(page).to have_content('Create Quota')
        expect(page).to have_content('Awaiting cross-check')
        expect(page).to have_content('View')
        expect(page).to_not have_content('Withdraw/edit')
      end
    end

    context 'another user has created a workbasket which is not awaiting cross check' do
      let!(:another_user) do
        create(:user)
      end

      let!(:other_users_unsubmitted_workbasket) do
        create(:workbasket,
               user_id: another_user.id,
               title: '091234',
               type: :create_quota,
               status: :new_in_progress,)
      end

      it 'does not display other users workbasket data' do
        visit root_path

        expect(page).to have_content(current_users_workbasket.title)
        expect(page).to have_content('Create Measure')
        expect(page).to have_content('New - in progress')
        expect(page).to have_content(Date.today.strftime('%d %b %Y'))
        expect(page).to have_content('Continue')

        expect(page).to_not have_content(other_users_unsubmitted_workbasket.title)
      end
    end

    context 'another user has created a workbasket which is awaiting approval' do
      let!(:another_user) do
        create(:user)
      end

      let!(:other_users_awaiting_approval_workbasket) do
        create(:workbasket,
          user_id: another_user.id,
          title: '091234',
          type: :create_quota,
          status: :awaiting_approval)
      end
      let(:current_user) { User.first }

      context 'current user is an approver' do
        it 'displays other users workbasket data' do
          current_user.approver_user = true
          current_user.save
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user)

          visit root_path

          expect(page).to have_content(other_users_awaiting_approval_workbasket.title)
          expect(page).to have_content('Create Quota')
          expect(page).to have_content('Awaiting approval')
          expect(page).to have_content('View')
          expect(page).to_not have_content('Withdraw/edit')
        end
      end

      context 'current user is not an approver' do
        it 'displays other users workbasket data' do
          current_user.approver_user = false
          current_user.save
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user)

          visit root_path

          expect(page).to_not have_content(other_users_awaiting_approval_workbasket.title)
          expect(page).to_not have_content('Create Quota')
          expect(page).to_not have_content('Awaiting approval')
          expect(page).to_not have_content('View')
          expect(page).to_not have_content('Withdraw/edit')
        end
      end
    end
  end
end
