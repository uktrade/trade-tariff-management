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

    describe "ON2" do
      it "valid" do
        qon1 = create :quota_order_number,
                      validity_start_date: 3.years.ago,
                      validity_end_date: 2.years.ago
        qon2 = create :quota_order_number,
                      validity_start_date: 1.year.ago,
                      validity_end_date: 6.months.ago
        qon3 = build :quota_order_number,
                     quota_order_number_id: qon1.quota_order_number_id,
                     validity_start_date: 1.year.ago
        expect(qon3).to be_conformant
      end

      it "invalid" do
        qon1 = create :quota_order_number,
                      validity_start_date: 4.years.ago,
                      validity_end_date: 2.years.ago
        qon2 = build :quota_order_number,
                     quota_order_number_id: qon1.quota_order_number_id,
                     validity_start_date: 3.years.ago,
                     validity_end_date: 2.years.ago
        expect(qon2).to_not be_conformant
        expect(qon2.conformance_errors).to have_key(:ON2)
      end
    end

    describe "ON3" do
      it "valid" do
        qon = build :quota_order_number,
                    validity_start_date: 10.days.ago,
                    validity_end_date: 5.days.ago
        expect(qon).to be_conformant
      end

      it "invalid" do
        qon = build :quota_order_number,
                    validity_start_date: 5.days.ago,
                    validity_end_date: 10.days.ago
        expect(qon).to_not be_conformant
        expect(qon.conformance_errors).to have_key(:ON3)
      end
    end

    describe "ON4" do
      it "valid" do
        qon = create :quota_order_number
        ga = create :geographical_area
        qono = create :quota_order_number_origin,
                      quota_order_number_sid: qon.quota_order_number_sid,
                      geographical_area_sid: ga.geographical_area_sid
        expect(qon).to be_conformant
      end

      it "invalid" do
        qon = create :quota_order_number
        qono = create :quota_order_number_origin,
                      quota_order_number_sid: qon.quota_order_number_sid
        expect(qon).to_not be_conformant
        expect(qon.conformance_errors).to have_key(:ON4)
      end
    end
  end
end
