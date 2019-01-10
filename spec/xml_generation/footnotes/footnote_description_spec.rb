require 'rails_helper'

describe "FootnoteDescription XML generation" do
  let(:db_record) do
    create(:footnote_description, :xml)
  end

  let(:data_namespace) do
    "oub:footnote.description"
  end

  let(:fields_to_check) do
    %i[
      footnote_description_period_sid
      language_id
      footnote_type_id
      footnote_id
      description
    ]
  end

  include_context "xml_generation_record_context"
end
