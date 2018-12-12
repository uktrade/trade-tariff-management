require 'rails_helper'

describe "QuotaBlockingPeriod XML generation" do
  let(:db_record) do
    create(:quota_blocking_period)
  end

  let(:data_namespace) do
    "oub:quota.blocking.period"
  end

  let(:fields_to_check) do
    %i[
      quota_blocking_period_sid
      quota_definition_sid
      blocking_start_date
      blocking_end_date
      blocking_period_type
      description
    ]
  end

  include_context "xml_generation_record_context"
end
