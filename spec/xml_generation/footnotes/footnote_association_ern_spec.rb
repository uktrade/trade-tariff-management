require 'rails_helper'

describe "FootnoteAssociationErn XML generation" do
  let(:db_record) do
    create(:footnote_association_ern, :xml)
  end

  let(:data_namespace) do
    "oub:footnote.association.ern"
  end

  let(:fields_to_check) do
    %i[
      export_refund_nomenclature_sid
      footnote_type
      footnote_id
      goods_nomenclature_item_id
      additional_code_type
      export_refund_code
      productline_suffix
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
