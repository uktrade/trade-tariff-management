require 'rails_helper'

describe "ModificationRegulation XML generation" do

  let(:db_record) do
    create(:modification_regulation, :xml)
  end

  let(:data_namespace) do
    "oub:modification.regulation"
  end

  let(:fields_to_check) do
    [
      :modification_regulation_role,
      :modification_regulation_id,
      :validity_start_date,
      :validity_end_date,
      :published_date,
      :officialjournal_number,
      :officialjournal_page,
      :base_regulation_role,
      :base_regulation_id,
      :replacement_indicator,
      :stopped_flag,
      :information_text,
      :approved_flag,
      :explicit_abrogation_regulation_role,
      :explicit_abrogation_regulation_id,
      :effective_end_date,
      :complete_abrogation_regulation_role,
      :complete_abrogation_regulation_id
    ]
  end

  include_context "xml_generation_record_context"
end
