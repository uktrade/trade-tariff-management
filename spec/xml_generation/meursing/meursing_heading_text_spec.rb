require 'rails_helper'

describe "MeursingHeadingText XML generation" do
  let(:db_record) do
    create(:meursing_heading_text, :xml)
  end

  let(:data_namespace) do
    "oub:meursing.heading.text"
  end

  let(:fields_to_check) do
    %i[
      meursing_table_plan_id
      meursing_heading_number
      row_column_code
      language_id
      description
    ]
  end

  include_context "xml_generation_record_context"
end
