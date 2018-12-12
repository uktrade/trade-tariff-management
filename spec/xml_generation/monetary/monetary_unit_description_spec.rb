require 'rails_helper'

describe "MonetaryUnitDescription XML generation" do
  let(:db_record) do
    create(:monetary_unit_description, :xml)
  end

  let(:data_namespace) do
    "oub:monetary.unit.description"
  end

  let(:fields_to_check) do
    %i[
      monetary_unit_code
      language_id
      description
    ]
  end

  include_context "xml_generation_record_context"
end
