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

  let!(:regulation_group) do
    create(:regulation_group)
  end

  let!(:regulation_group_description) do
    create(:regulation_group_description, regulation_group_id: regulation_group.regulation_group_id)
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

  let(:base_filed_values) do
    [
        {name: 'Prefix', value: %w(C D A I J R).sample, type: :select},
        {name: 'Publication year', value: Forgery(:basic).number(at_least: 10, at_most: 19).to_s, type: :text},
        {name: 'Regulation number', value: Forgery(:basic).number(at_least: 1000, at_most: 9999).to_s, type: :text},
        {name: 'Number suffix', value: Forgery(:basic).number(at_least: 0, at_most: 9).to_s, type: :text},
        # 'Replacement indicator', always filled
        {name: 'Information text', value: Forgery('lorem_ipsum').sentence, type: :text},
        {name: 'Operation date', value: operation_date.strftime("%d/%m/%Y"), type: :date},
    ]
  end

  let(:filed_values) do
    base_filed_values
  end

  context 'filled regulation type' do

    context 'click on Create regulation' do
      it 'should show validation errors' do
        visit_create_regulation

        custom_select regulation_type, from: 'Specify the regulation type'
        click_on 'Create regulation'

        required_fields.each do |field|
          expect(page).to have_content "#{field} can't be blank!"
        end

      end
    end

    context 'filled required fields' do

      context 'click on Create regulation' do
        context 'click on Submit for cross-check' do
          it 'should be okay' do
            visit_create_regulation

            custom_select regulation_type, from: 'Specify the regulation type'
            filed_values.each do |value|
              case value[:type]
                when :text
                  fill_in value[:name], with: value[:value]
                when :select
                  custom_select value[:value], from: value[:name]
                when :date
                  fill_date value[:name], with: value[:value]
              end
            end

            click_on 'Create regulation'
            expect(page).to have_content('Review and submit')

            click_on 'Submit for cross-check'
            expect(page).to have_content('Workbasket submitted for review')
          end
        end
      end

    end

  end

end