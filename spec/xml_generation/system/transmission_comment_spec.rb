require 'rails_helper'

describe "TransmissionComment XML generation" do

  let(:db_record) do
    create(:transmission_comment)
  end

  let(:data_namespace) do
    "oub:transmission.comment"
  end

  let(:fields_to_check) do
    [
      :comment_sid,
      :language_id,
      :comment_text
    ]
  end

  include_context "xml_generation_record_context"
end
