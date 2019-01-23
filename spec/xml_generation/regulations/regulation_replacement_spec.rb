require 'rails_helper'

describe "RegulationReplacement XML generation" do
  let(:db_record) do
    create(:regulation_replacement)
  end

  let(:data_namespace) do
    "oub:regulation.replacement"
  end

  let(:fields_to_check) do
    %i[
      replacing_regulation_role
      replacing_regulation_id
      replaced_regulation_role
      replaced_regulation_id
      measure_type_id
      geographical_area_id
      chapter_heading
    ]
  end

  include_context "xml_generation_record_context"
end
