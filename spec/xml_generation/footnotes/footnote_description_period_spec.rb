require 'rails_helper'

describe "FootnoteDescriptionPeriod XML generation" do
  let(:db_record) do
    create(:footnote_description_period, :xml)
  end

  let(:data_namespace) do
    "oub:footnote.description.period"
  end

  let(:fields_to_check) do
    %i[
      footnote_description_period_sid
      footnote_type_id
      footnote_id
      validity_start_date
    ]
  end

  include_context "xml_generation_record_context"
end
