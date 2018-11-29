require 'rails_helper'

describe 'workbasket table', js: true do

  let!(:user) do
    create(:user)
  end

  context 'user have no workbaskets' do

    it 'should contain no data' do
      visit root_path
      expect(page).to have_content('You are not working with any items at the moment.')
    end

  end

  context 'user with workbasket' do

    let!(:workbasket1) do
      create(:workbasket,
             user_id: user.id,
             title: '093456',
             type: :create_measures,
             status: :new_in_progress,
      )
    end

    it 'should display user workbasket data' do
      visit root_path

      expect(page).to have_content('093456')
      expect(page).to have_content('Create Measure')
      expect(page).to have_content('New - in progress')
      expect(page).to have_content(Date.today.strftime('%d %b %Y'))
      expect(page).to have_content('Continue')
    end

    context 'another user with workbasket' do

      let!(:another_user) do
        create(:user)
      end

      let!(:workbasket2) do
        create(:workbasket,
               user_id: another_user.id,
               title: '091234',
               type: :create_quota,
               status: :awaiting_cross_check,
        )
      end

      it 'should display another users workbasket data' do
        visit root_path

        expect(page).to have_content('093456')
        expect(page).to have_content('Create Measure')
        expect(page).to have_content('New - in progress')
        expect(page).to have_content(Date.today.strftime('%d %b %Y'))
        expect(page).to have_content('Continue')

        expect(page).to have_content('091234')
        expect(page).to have_content('Create Quota')
        expect(page).to have_content('Awaiting cross-check')
        expect(page).to have_content('View')
      end
    end

    context 'another workbasket in another state' do

      let!(:workbasket2) do
        create(:workbasket,
               user_id: user.id,
               title: '091234',
               type: :create_quota,
               status: :awaiting_cross_check,
        )
      end

      it 'should display all users workbasket data' do
        visit root_path

        expect(page).to have_content('093456')
        expect(page).to have_content('Create Measure')
        expect(page).to have_content('New - in progress')
        expect(page).to have_content(Date.today.strftime('%d %b %Y'))
        expect(page).to have_content('Continue')

        expect(page).to have_content('091234')
        expect(page).to have_content('Create Quota')
        expect(page).to have_content('Awaiting cross-check')
        expect(page).to have_content('View')
      end
    end
  end
end
