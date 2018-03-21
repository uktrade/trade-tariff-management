require 'rails_helper'

describe "BaseRegulation XML generation" do

  let(:db_record) do
    create(:base_regulation, :xml)
  end

  let(:data_namespace) do
    "oub:base.regulation"
  end

  let(:fields_to_check) do
    [
      :base_regulation_role,
      :base_regulation_id,
      :published_date,
      :officialjournal_number,
      :officialjournal_page,
      :validity_start_date,
      :validity_end_date,
      :effective_end_date,
      :community_code,
      :regulation_group_id,
      :antidumping_regulation_role,
      :related_antidumping_regulation_id,
      :complete_abrogation_regulation_role,
      :complete_abrogation_regulation_id,
      :explicit_abrogation_regulation_role,
      :explicit_abrogation_regulation_id,
      :replacement_indicator,
      :stopped_flag,
      :information_text,
      :approved_flag
    ]
  end

  include_context "xml_generation_record_context"
end
