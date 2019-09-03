require 'rails_helper'

describe 'base regulation', js: true do
  include_context 'create_regulation_base_context'

  let(:regulation_type) do
    'Base regulation'
  end

  let(:required_fields) do
    base_required_fields.
        concat([
                   { label: 'Validity start date' },
                   { label: 'Regulation group id' }
               ])
  end

  let(:required_filed_values) do
    base_required_filed_values.
        concat([
                   { id: '#validity_start_date', value: validity_start_date, type: :date },
                   { name: 'What type of regulation do you want to create?', value: regulation_group.regulation_group_id, type: :select },
               ])
  end

  let(:filed_values) do
    required_filed_values.
        concat([
                   { id: '#validity_end_date', value: validity_end_date, type: :date },
               ])
  end
end
