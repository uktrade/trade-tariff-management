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

end