require 'rails_helper'

shared_context "measures_date_universal_context" do
  let(:a_measure) do
    create(:measure, field_name.to_sym => 3.days.ago)
  end

  let(:b_measure) do
    create(:measure, field_name.to_sym => 2.days.ago)
  end

  let(:c_measure) do
    create(:measure, field_name.to_sym => 1.days.ago)
  end

  let(:d_measure) do
    create(:measure, field_name.to_sym => nil)
  end

  before do
    a_measure
    b_measure
    c_measure
    d_measure
  end
end
