require 'rails_helper'

describe "AdditionalCodeTypeDescription XML generation" do
  let(:db_record) do
    create(:additional_code_type_description, :xml)
  end

  let(:data_namespace) do
    "oub:additional.code.type.description"
  end

  let(:fields_to_check) do
    %i[
      additional_code_type_id
      language_id
      description
    ]
  end

  include_context "xml_generation_record_context"
end
