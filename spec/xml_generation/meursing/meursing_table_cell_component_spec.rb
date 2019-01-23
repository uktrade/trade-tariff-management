require 'rails_helper'

describe "MeursingTableCellComponent XML generation" do
  let(:db_record) do
    create(:meursing_table_cell_component, :xml)
  end

  let(:data_namespace) do
    "oub:meursing.table.cell.component"
  end

  let(:fields_to_check) do
    %i[
      meursing_additional_code_sid
      meursing_table_plan_id
      heading_number
      row_column_code
      subheading_sequence_number
      validity_start_date
      validity_end_date
      additional_code
    ]
  end

  include_context "xml_generation_record_context"
end
