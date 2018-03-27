require 'rails_helper'

describe "LanguageDescription XML generation" do

  let(:db_record) do
    create(:language_description)
  end

  let(:data_namespace) do
    "oub:language.description"
  end

  let(:fields_to_check) do
    [
      :language_code_id,
      :language_id,
      :description
    ]
  end

  include_context "xml_generation_record_context"
end
