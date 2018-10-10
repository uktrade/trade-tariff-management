require 'rails_helper'

describe 'modification regulation', js: true do

  include_context 'create_regulation_base_context'

  let(:regulation_type) do
    'Modification'
  end

  let(:required_fields) do
    base_required_fields.
        concat([
                   'Base regulation id',
                   'Validity start date',
               ])
  end

  let(:required_filed_values) do
    base_required_filed_values.
        concat([
                   {name: 'Specify the base regulation', value: base_regulation.base_regulation_id, type: :select},
                   {name: 'Start date', value: validity_start_date.strftime("%d/%m/%Y"), type: :date},
               ])
  end

  let(:filed_values) do
    required_filed_values.
        concat([
                   {name: 'End date', value: validity_end_date.strftime("%d/%m/%Y"), type: :date},
                   {name: 'Effective end date', value: effective_end_date.strftime("%d/%m/%Y"), type: :date},
               ])
  end

end