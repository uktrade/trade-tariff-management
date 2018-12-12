require 'rails_helper'

describe "QuotaDefinition XML generation" do
  let(:db_record) do
    create(:quota_definition, :xml)
  end

  let(:data_namespace) do
    "oub:quota.definition"
  end

  let(:fields_to_check) do
    %i[
      quota_definition_sid
      quota_order_number_id
      validity_start_date
      validity_end_date
      quota_order_number_sid
      volume
      initial_volume
      measurement_unit_code
      maximum_precision
      critical_state
      critical_threshold
      monetary_unit_code
      measurement_unit_qualifier_code
      description
    ]
  end

  include_context "xml_generation_record_context"
end
