require 'rails_helper'

describe "GeographicalAreaMembership XML generation" do
  let(:db_record) do
    create(:geographical_area_membership, :xml)
  end

  let(:data_namespace) do
    "oub:geographical.area.membership"
  end

  let(:fields_to_check) do
    %i[
      geographical_area_sid
      geographical_area_group_sid
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
