require 'rails_helper'

describe "MeursingSubheading XML generation" do
  let(:db_record) do
    create(:meursing_subheading, :xml)
  end

  let(:data_namespace) do
    "oub:meursing.subheading"
  end

  let(:fields_to_check) do
    %i[
      meursing_table_plan_id
      meursing_heading_number
      row_column_code
      subheading_sequence_number
      validity_start_date
      validity_end_date
      description
    ]
  end

  include_context "xml_generation_record_context"
end
