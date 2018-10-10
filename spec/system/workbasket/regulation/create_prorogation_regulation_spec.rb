require 'rails_helper'

describe 'prorogation regulation', js: true do

  include_context 'create_regulation_base_context'

  let(:regulation_type) do
    'Prorogation'
  end

  let(:required_fields) do
    base_required_fields.
        concat([
                   'Published date',
               ])
  end

  let(:required_filed_values) do
    base_required_filed_values.
        concat([
                   {name: 'Published date', value: published_date.strftime("%d/%m/%Y"), type: :date},
               ])
  end

  let(:filed_values) do
    required_filed_values
  end

end