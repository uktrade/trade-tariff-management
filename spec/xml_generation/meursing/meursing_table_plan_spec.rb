require 'rails_helper'

describe "MeursingTablePlan XML generation" do
  let(:db_record) do
    create(:meursing_table_plan, :xml)
  end

  let(:data_namespace) do
    "oub:meursing.table.plan"
  end

  let(:fields_to_check) do
    %i[
      meursing_table_plan_id
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
