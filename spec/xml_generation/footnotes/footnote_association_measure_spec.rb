require 'rails_helper'

describe "FootnoteAssociationMeasure XML generation" do
  let(:db_record) do
    create(:footnote_association_measure)
  end

  let(:data_namespace) do
    "oub:footnote.association.measure"
  end

  let(:fields_to_check) do
    %i[
      measure_sid
      footnote_type_id
      footnote_id
    ]
  end

  include_context "xml_generation_record_context"
end
