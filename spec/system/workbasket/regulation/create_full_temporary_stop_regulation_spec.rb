require 'rails_helper'

describe 'full temporary stop regulation', js: true do

  include_context 'create_regulation_base_context'

  let(:regulation_type) do
    'Regulation which temporarily suspends all another regulation (FTS - Full Temporary Stop)'
  end

  let(:required_fields) do
    base_required_fields.
        concat([
                   'Validity start date',
                   'Published date',
               ])
  end

  let(:required_filed_values) do
    base_required_filed_values.
        concat([
                   {name: 'Start date', value: validity_start_date.strftime("%d/%m/%Y"), type: :date},
                   {name: 'Published date', value: published_date.strftime("%d/%m/%Y"), type: :date},
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