require 'rails_helper'

shared_context 'create_regulation_base_context' do
  include_context 'regulation_page_context'

  before do
    create(:regulation_role_type_description,
           regulation_role_type_id: 1, description: 'Base regulation')
  end

  let!(:regulation_group) do
    create(:regulation_group)
  end

  let!(:regulation_group_description) do
    create(:regulation_group_description, regulation_group_id: regulation_group.regulation_group_id)
  end

  let!(:base_regulation) do
    create(:base_regulation,
           base_regulation_id:
               %w(C D A I J R).sample +
               Forgery(:basic).number(at_least: 10, at_most: 19).to_s +
               Forgery(:basic).number(at_least: 1000, at_most: 9999).to_s +
               Forgery(:basic).number(at_least: 0, at_most: 9).to_s,
           replacement_indicator: 0,
           information_text: Forgery('lorem_ipsum').sentence)
  end

  let(:published_date) do
    validity_start_date
  end

  let(:abrogation_date) do
    validity_start_date
  end

  let(:base_required_fields) do
    [
        # TODO: use base regulation id
        # 'Prefix',
        # 'Publication year',
        # 'Regulation number',
        # 'Number suffix',
        { label: 'Regulation identifier', id: 'workbasket_forms_create_regulation_form_base_regulation_id' },
        { label: 'Legal ID', id: 'workbasket_forms_create_regulation_form_legal_id' },
        { label: 'Description', id: 'workbasket_forms_create_regulation_form_description' },
        { label: 'Reference URL', id: 'workbasket_forms_create_regulation_form_reference_url' }
    ]
  end

  let(:required_fields) do
    base_required_fields
  end

  let(:base_required_filed_values) do
    [
        # { name: 'Prefix', value: "Decision", type: :select },
        # { name: 'Publication year', value: Forgery(:basic).number(at_least: 10, at_most: 19).to_s, type: :text },
        # { name: 'Regulation number', value: Forgery(:basic).number(at_least: 1000, at_most: 9999).to_s, type: :text },
        # { name: 'Number suffix', value: Forgery(:basic).number(at_least: 0, at_most: 9).to_s, type: :text },
        { name: 'Regulation identifier', id: 'workbasket_forms_create_regulation_form_base_regulation_id', value: 'C1234567', type: :text },
        { name: 'Legal ID', id: 'workbasket_forms_create_regulation_form_legal_id', value: Forgery('lorem_ipsum').characters, type: :text },
        { name: 'Description', id: 'workbasket_forms_create_regulation_form_description', value: Forgery('lorem_ipsum').sentence, type: :text },
        { name: 'Reference URL', id: 'workbasket_forms_create_regulation_form_reference_url', value: Forgery(:internet).domain_name, type: :text }
    ]
  end

  let(:required_filed_values) do
    base_required_filed_values
  end

  let(:base_filed_values) do
    base_required_filed_values
  end

  let(:filed_values) do
    base_filed_values
  end

  context 'filled regulation type' do
    context 'click on Create regulation' do
      it 'shows validation errors' do
        visit_create_regulation

        click_on 'Create regulation'

        required_fields.each do |field|
          case field[:label]
          when "Legal ID"
            expect(page).to have_content "Public-facing regulation name can't be blank!"
          when "Validity start date"
            expect(page).to have_content "Start date can't be blank!"
          when "Regulation group id"
            expect(page).to have_content "Regulation group can't be blank!"
          else
            expect(page).to have_content "#{field[:label]} can't be blank!"
          end
        end
      end
    end

    context 'filled required fields' do
      context 'click on Create regulation' do
        context 'click on Submit for cross-check' do
          it 'is okay' do
            visit_create_regulation

            fill_in_form(required_filed_values)

            click_on 'Create regulation'
            expect(page).to have_content('Review and submit')

            click_on 'Submit for cross-check'
            expect(page).to have_content('Workbasket submitted for review')
          end
        end
      end
    end

    context 'filled all fields' do
      context 'click on Create regulation' do
        context 'click on Submit for cross-check' do
          it 'is okay' do
            visit_create_regulation

            fill_in_form(filed_values)

            click_on 'Create regulation'
            expect(page).to have_content('Review and submit')

            click_on 'Submit for cross-check'
            expect(page).to have_content('Workbasket submitted for review')
          end
        end
      end
    end
  end

  private

  def fill_in_form(form_values)
    form_values.each do |value|
      case value[:type]
      when :text
        fill_in (value[:id] || value[:name]), with: value[:value]
      when :select
        within("#regulation_group") do
          select_dropdown_value(value[:value])
        end
      when :date
        input_date((value[:id] || value[:name]), value[:value])
      end
    end
  end
end
