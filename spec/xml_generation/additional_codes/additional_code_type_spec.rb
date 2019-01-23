require 'rails_helper'

describe "AdditionalCodeType XML generation" do
  let(:db_record) do
    create(:additional_code_type, :with_meursing_table_plan, :xml)
  end

  let(:data_namespace) do
    "oub:additional.code.type"
  end

  let(:fields_to_check) do
    %i[
      additional_code_type_id
      application_code
      meursing_table_plan_id
      validity_start_date
      validity_end_date
    ]
  end

  include_context "xml_generation_record_context"
end
