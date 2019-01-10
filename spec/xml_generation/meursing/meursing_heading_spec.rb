require 'rails_helper'

describe "MeursingHeading XML generation" do
  let(:db_record) do
    create(:meursing_heading, :xml)
  end

  let(:data_namespace) do
    "oub:meursing.heading"
  end

  let(:fields_to_check) do
    %i[
      meursing_table_plan_id
      meursing_heading_number
      row_column_code
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
