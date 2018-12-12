require 'rails_helper'

describe QuotaOrderNumber do
  describe 'validations' do
    describe "ON1" do
      it { is_expected.to validate_uniqueness.of(%i[quota_order_number_id validity_start_date]) }

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

    describe "ON7" do
      it "valid" do
        qon = build :quota_order_number,
                     validity_start_date: 15.days.ago,
                     validity_end_date: 5.days.ago
        qono = create :quota_order_number_origin,
                      :with_geographical_area,
                      quota_order_number_sid: qon.quota_order_number_sid,
                      validity_start_date: 12.days.ago,
                      validity_end_date: 8.days.ago
        expect(qon).to be_conformant
      end

      it "invalid" do
        qon = create :quota_order_number,
                     validity_start_date: 10.days.ago,
                     validity_end_date: 5.days.ago
        qono = create :quota_order_number_origin,
                      quota_order_number_sid: qon.quota_order_number_sid,
                      validity_start_date: 12.days.ago,
                      validity_end_date: 8.days.ago
        expect(qon).to_not be_conformant
        expect(qon.conformance_errors).to have_key(:ON7)
      end
    end

    describe "ON8" do
      it "valid" do
        qon = build :quota_order_number,
                     validity_start_date: 15.days.ago,
                     validity_end_date: 5.days.ago
        qdefinition = create :quota_definition,
                      quota_order_number_id: qon.quota_order_number_id,
                      quota_order_number_sid: qon.quota_order_number_sid,
                      validity_start_date: 12.days.ago,
                      validity_end_date: 8.days.ago
        expect(qon).to be_conformant
      end

      #
      # ON8 currently disabled
      # return it back once you solve issues in Create Quota with this conformance rule
      #
      # it "invalid" do
      #   qon = build :quota_order_number,
      #                validity_start_date: 10.days.ago,
      #                validity_end_date: 5.days.ago
      #   qdefinition = create :quota_definition,
      #                 quota_order_number_id: qon.quota_order_number_id,
      #                 quota_order_number_sid: qon.quota_order_number_sid,
      #                 validity_start_date: 12.days.ago,
      #                 validity_end_date: 8.days.ago
      #   expect(qon).to_not be_conformant
      #   expect(qon.conformance_errors).to have_key(:ON8)
      # end
    end

    describe "ON9" do
      it "valid" do
        measure = create :measure,
                  ordernumber: generate(:quota_order_number_id),
                  validity_start_date: 12.days.ago,
                  validity_end_date: 8.days.ago
        qon = build :quota_order_number,
                    validity_start_date: 15.days.ago,
                    validity_end_date: 5.days.ago,
                    quota_order_number_id: measure.ordernumber
        expect(qon).to be_conformant
      end

      #
      # ON9 - currently raising issue in Create Quota flow
      # Sequel::DatabaseError (PG::UndefinedColumn: ERROR:  column "effective_start_date" does not exist
      # return it back once you solve issues in Create Quota with this conformance rule
      #
      # it "invalid" do
      #   measure = create :measure,
      #             ordernumber: generate(:quota_order_number_id),
      #             validity_start_date: 20.days.ago,
      #             validity_end_date: 8.days.ago
      #   qon = build :quota_order_number,
      #               validity_start_date: 15.days.ago,
      #               validity_end_date: 5.days.ago,
      #               quota_order_number_id: measure.ordernumber
      #   expect(qon).to_not be_conformant
      #   expect(qon.conformance_errors).to have_key(:ON9)
      # end
    end

    describe "ON11" do
      it "valid" do
        bottom_date = Date.new(2007, 12, 31)
        measure = create :measure,
                  ordernumber: generate(:quota_order_number_id),
                  validity_start_date: bottom_date - 1.day
        qon = build :quota_order_number,
                    validity_start_date: 15.days.ago,
                    validity_end_date: 5.days.ago,
                    quota_order_number_id: measure.ordernumber
        expect(qon.conformant_for?(:destroy)).to be_truthy
      end

      it "invalid" do
        measure = create :measure,
                  ordernumber: generate(:quota_order_number_id),
                  validity_start_date: 12.days.ago,
                  validity_end_date: 8.days.ago
        qon = build :quota_order_number,
                    validity_start_date: 15.days.ago,
                    validity_end_date: 5.days.ago,
                    quota_order_number_id: measure.ordernumber
        expect(qon.conformant_for?(:destroy)).to be_falsey
        expect(qon.conformance_errors).to have_key(:ON11)
      end
    end
  end
end
