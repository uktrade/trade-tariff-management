require 'rails_helper'

shared_context "system_test_base_context" do

  let!(:user) do
    create(:user)
  end

  let(:validity_start_date) do
    1.day.from_now
  end

  let(:validity_end_date) do
    validity_start_date + 1.year
  end

  let(:operation_date) do
    validity_start_date
  end

end