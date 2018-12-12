require 'rails_helper'

describe "DutyExpressionDescription XML generation" do
  let(:db_record) do
    create(:duty_expression_description, :xml)
  end

  let(:data_namespace) do
    "oub:duty.expression.description"
  end

  let(:fields_to_check) do
    %i[
      duty_expression_id
      language_id
      description
    ]
  end

  include_context "xml_generation_record_context"
end
