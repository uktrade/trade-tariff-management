require 'rails_helper'

describe 'provisional anti dumping countervailing duty regulation', js: true do

  include_context 'create_regulation_base_context'

  let(:regulation_type) do
    'Provisional anti-dumping/countervailing duty'
  end

  let(:required_fields) do
    base_required_fields.
        concat([
                   'Related antidumping regulation id',
                   'Validity start date',
                   'Regulation group id',
               ])
  end

  let(:required_filed_values) do
    base_required_filed_values.
        concat([
                   {name: 'Specify a related antidumping regulation', value: base_regulation.base_regulation_id, type: :select},
                   {name: 'Start date', value: validity_start_date.strftime("%d/%m/%Y"), type: :date},
                   {name: 'Specify the regulation group', value: regulation_group.regulation_group_id, type: :select},
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