require 'rails_helper'

describe "QuotaSuspensionPeriod XML generation" do
  let(:db_record) do
    create(:quota_suspension_period)
  end

  let(:data_namespace) do
    "oub:quota.suspension.period"
  end

  let(:fields_to_check) do
    %i[
      quota_suspension_period_sid
      quota_definition_sid
      suspension_start_date
      suspension_end_date
      description
    ]
  end

  include_context "xml_generation_record_context"
end
