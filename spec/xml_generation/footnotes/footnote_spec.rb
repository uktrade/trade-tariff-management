require 'rails_helper'

describe "Footnote XML generation" do
  let(:db_record) do
    create(:footnote, :xml)
  end

  let(:data_namespace) do
    "oub:footnote"
  end

  let(:fields_to_check) do
    %i[
      footnote_type_id
      footnote_id
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
