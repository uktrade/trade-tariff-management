require 'rails_helper'

describe "FootnoteTypeDescription XML generation" do
  let(:db_record) do
    create(:footnote_type_description, :xml)
  end

  let(:data_namespace) do
    "oub:footnote.type.description"
  end

  let(:fields_to_check) do
    %i[
      footnote_type_id
      language_id
      description
    ]
  end

  include_context "xml_generation_record_context"
end
