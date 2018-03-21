require 'rails_helper'

describe "Language XML generation" do

  let(:db_record) do
    create(:language, :xml)
  end

  let(:data_namespace) do
    "oub:language"
  end

  let(:fields_to_check) do
    [
      :language_id,
      :validity_start_date,
      :validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
