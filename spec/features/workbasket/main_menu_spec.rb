require 'rails_helper'

describe 'workbasket table', js: true do
  let!(:user) do
    create(:user)
  end

  context 'no workbaskets exist' do
    it 'contains no data' do
      visit root_path
      expect(page).to have_content('You are not working with any items at the moment.')
    end
  end

  context 'user has created a workbasket' do
    let!(:current_users_workbasket) do
      create(:workbasket,
             user_id: user.id,
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
  end
end
