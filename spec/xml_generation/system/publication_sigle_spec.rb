require 'rails_helper'

describe "PublicationSigle XML generation" do
  let(:db_record) do
    create(:publication_sigle, :xml)
  end

  let(:data_namespace) do
    "oub:publication.sigle"
  end

  let(:fields_to_check) do
    %i[
      code_type_id
      code
      publication_code
      publication_sigle
      validity_end_date
      validity_start_date
    ]
  end

  include_context "xml_generation_record_context"
end
