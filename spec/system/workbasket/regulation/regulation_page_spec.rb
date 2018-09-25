require 'rails_helper'

describe 'create_regulation_page', js: true do

  context 'root_path' do

    include_context 'system_test_base_context'

    context 'click on Create a regulation' do
      it 'should open regulation page' do
        visit root_path
        expect(page).to have_content 'Create a regulation'

        click_on 'Create a regulation'
        expect(page).to have_content 'Specify the regulation type'
      end
    end

  end

  context 'regulation page' do

    include_context 'regulation_page_context'

    context 'empty page' do
      context 'click on Create regulation' do
        it 'should show validation error' do
          visit_create_regulation
          click_on 'Create regulation'
          expect(page).to have_content 'You need to specify the regulation type!'
        end
      end
    end

  end

end