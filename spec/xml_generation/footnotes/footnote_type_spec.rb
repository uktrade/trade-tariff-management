require 'rails_helper'

describe "FootnoteType XML generation" do
  let!(:db_record) do
    create(:footnote_type, :xml)
  end

  let(:data_namespace) do
    "oub:footnote.type"
  end

  let(:fields_to_check) do
    %i[
      footnote_type_id
      application_code
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
