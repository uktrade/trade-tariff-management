require 'rails_helper'

describe "ProrogationRegulationAction XML generation" do
  let(:db_record) do
    create(:prorogation_regulation_action)
  end

  let(:data_namespace) do
    "oub:prorogation.regulation.action"
  end

  let(:fields_to_check) do
    %i[
      prorogation_regulation_role
      prorogation_regulation_id
      prorogated_regulation_role
      prorogated_regulation_id
      prorogated_date
    ]
  end

  include_context "xml_generation_record_context"
end
