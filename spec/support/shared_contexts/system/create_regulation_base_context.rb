require 'rails_helper'

shared_context 'create_regulation_base_context' do

  include_context 'regulation_page_context'

  before do
    create(:regulation_role_type_description,
           regulation_role_type_id: 1, description: 'Base regulation')
    create(:regulation_role_type_description,
           regulation_role_type_id: 2, description: 'Provisional anti-dumping/countervailing duty')
    create(:regulation_role_type_description,
           regulation_role_type_id: 3, description: 'Definitive anti-dumping/countervailing duty')
    create(:regulation_role_type_description,
           regulation_role_type_id: 4, description: 'Modification')
    create(:regulation_role_type_description,
           regulation_role_type_id: 5, description: 'Prorogation')
    create(:regulation_role_type_description,
           regulation_role_type_id: 6, description: 'Complete abrogation')
    create(:regulation_role_type_description,
           regulation_role_type_id: 7, description: 'Explicit abrogation')
    create(:regulation_role_type_description,
           regulation_role_type_id: 8, description: 'Regulation which temporarily suspends all another regulation (FTS - Full Temporary Stop)')
  end

  let(:effective_end_date) do
    validity_end_date + 1.day
  end

  let(:regulation_type) do
    ''
  end

  let(:base_required_fields) do
    [
      'Prefix',
      'Publication year',
      'Regulation number',
      'Number suffix',
      # 'Replacement indicator', always filled
      'Information text',
      'Operation date',
    ]
  end

  let(:required_fields) do
    base_required_fields
  end

  context 'filled regulation type' do

    context 'click on Create regulation' do
      it 'should show validation errors' do
        visit_create_regulation

        custom_select(regulation_type, from: 'Specify the regulation type')
        click_on 'Create regulation'

        required_fields.each do |field|
          expect(page).to have_content "#{field} can't be blank!"
        end

      end
    end

  end

end