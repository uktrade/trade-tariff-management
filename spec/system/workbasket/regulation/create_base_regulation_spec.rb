require 'rails_helper'

describe 'base regulation', js: true do

  include_context 'create_regulation_base_context'

  let(:regulation_type) do
    'Base regulation'
  end

  let(:required_fields) do
    base_required_fields.
        concat([
                   'Validity start date',
                   'Regulation group id',
               ])
  end

  let(:filed_values) do
    base_filed_values.
        concat([
                   {name: 'Start date', value: validity_start_date.strftime("%d/%m/%Y"), type: :date},
                   {name: 'Specify the regulation group', value: regulation_group.regulation_group_id, type: :select},
               ])
  end

end