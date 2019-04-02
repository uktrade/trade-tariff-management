require 'rails_helper'

describe 'create_regulation_page', js: true do
  context 'root_path' do
    include_context 'system_test_base_context'

    context 'click on Create regulation' do
      it 'opens regulation page' do
        visit root_path
        expect(page).to have_content 'Create a new regulation'

        click_on 'Create a new regulation'
        expect(page).to have_content 'What is the regulation identifier'
      end
    end
  end

  context 'regulation page' do
    include_context 'regulation_page_context'

    context 'empty page' do
      context 'click on Create a new regulation' do
        it 'shows validation error' do
          visit_create_regulation
          click_on 'Create regulation'
          expect(page).to have_content "Legal ID can't be blank!"
        end
      end
    end
  end
end
