require 'rails_helper'

describe QuotaOrderNumber do
  describe 'validations' do
    describe "ON1" do
      it { is_expected.to validate_uniqueness.of([:quota_order_number_id, :validity_start_date]) }

      it "invalid" do
        start_date = 3.years.ago
        qon1 = create :quota_order_number,
                      validity_start_date: start_date
        qon2 = build :quota_order_number,
                     validity_start_date: start_date,
                     quota_order_number_id: qon1.quota_order_number_id
        expect(qon2).to_not be_conformant
        expect(qon2.conformance_errors).to have_key(:ON1)
      end
    end
  end
end
