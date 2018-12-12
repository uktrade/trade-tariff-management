require 'rails_helper'

describe "FootnoteAssociationAdditionalCode XML generation" do
  let(:db_record) do
    create(:footnote_association_additional_code, :xml)
  end

  let(:data_namespace) do
    "oub:footnote.association.additional.code"
  end

  let(:fields_to_check) do
    %i[
      additional_code_sid
      footnote_type_id
      footnote_id
      additional_code_type_id
      additional_code
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
