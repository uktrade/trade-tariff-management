require 'rails_helper'

describe 'complete abrogation regulation', js: true do

  include_context 'create_regulation_base_context'

  let(:regulation_type) do
    'Complete abrogation'
  end

  let(:required_fields) do
    base_required_fields.
        concat([
                   'Base regulation id',
                   'Published date',
               ])
  end

  let(:required_filed_values) do
    base_required_filed_values.
        concat([
                   {name: 'Specify the base regulation', value: base_regulation.base_regulation_id, type: :select},
                   {name: 'Published date', value: published_date.strftime("%d/%m/%Y"), type: :date},
               ])
  end

  let(:filed_values) do
    required_filed_values
  end

end