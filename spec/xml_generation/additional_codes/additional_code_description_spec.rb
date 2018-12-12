require 'rails_helper'

describe "AdditionalCodeDescription XML generation" do
  let(:db_record) do
    create(:additional_code_description, :xml)
  end

  let(:data_namespace) do
    "oub:additional.code.description"
  end

  let(:fields_to_check) do
    %i[
      additional_code_description_period_sid
      language_id
      additional_code_sid
      additional_code_type_id
      additional_code
      description
    ]
  end

  include_context "xml_generation_record_context"
end
