require 'rails_helper'

describe QuotaOrderNumberOrigin do
  describe "validations" do
    describe "ON5" do
      it "valid" do
        qon = create :quota_order_number
        gasid = generate :geographical_area_sid
        qono1 = create :quota_order_number_origin,
                       quota_order_number_sid: qon.quota_order_number_sid,
                       geographical_area_sid: gasid,
                       validity_start_date: 20.days.ago,
                       validity_end_date: 10.days.ago
        qono2 = build :quota_order_number_origin,
                      quota_order_number_sid: qon.quota_order_number_sid,
                      geographical_area_sid: gasid,
                      validity_start_date: 9.days.ago,
                      validity_end_date: 5.days.ago
        expect(qono2).to be_conformant
      end

      it "invalid" do
        qon = create :quota_order_number
        gasid = generate :geographical_area_sid
        qono1 = create :quota_order_number_origin,
                       quota_order_number_sid: qon.quota_order_number_sid,
                       geographical_area_sid: gasid,
                       validity_start_date: 20.days.ago,
                       validity_end_date: 5.days.ago
        qono2 = build :quota_order_number_origin,
                      quota_order_number_sid: qon.quota_order_number_sid,
                      geographical_area_sid: gasid,
                      validity_start_date: 15.days.ago,
                      validity_end_date: 10.days.ago
        expect(qono2).not_to be_conformant
        expect(qono2.conformance_errors).to have_key(:ON5)
      end
    end

    describe "ON6" do
      it "valid" do
        ga = create :geographical_area,
                    validity_start_date: 15.days.ago,
                    validity_end_date: 5.days.ago
        qono = build :quota_order_number_origin,
                     geographical_area_sid: ga.geographical_area_sid,
                     validity_start_date: 12.days.ago,
                     validity_end_date: 8.days.ago
        expect(qono).to be_conformant
      end

      it "invalid" do
        ga = create :geographical_area,
                    validity_start_date: 10.days.ago,
                    validity_end_date: 5.days.ago
        qono = build :quota_order_number_origin,
                      geographical_area_sid: ga.geographical_area_sid,
                      validity_start_date: 12.days.ago,
                      validity_end_date: 8.days.ago
        expect(qono).not_to be_conformant
        expect(qono.conformance_errors).to have_key(:ON6)
      end
    end

    describe "ON10" do
      it "valid" do
        measure = create :measure,
                  ordernumber: generate(:quota_order_number_id),
                  validity_start_date: 12.days.ago,
                  validity_end_date: 8.days.ago
        qon = create :quota_order_number,
                    quota_order_number_id: measure.ordernumber
        qono = build :quota_order_number_origin,
                     quota_order_number_sid: qon.quota_order_number_sid,
                     validity_start_date: 15.days.ago,
                     validity_end_date: 5.days.ago
        expect(qono).to be_conformant
      end

      it "invalid" do
        measure = create :measure,
                  ordernumber: generate(:quota_order_number_id),
                  validity_start_date: 20.days.ago,
                  validity_end_date: 8.days.ago
        qon = create :quota_order_number,
                    quota_order_number_id: measure.ordernumber
        qono = build :quota_order_number_origin,
                     quota_order_number_sid: qon.quota_order_number_sid,
                     validity_start_date: 15.days.ago,
                     validity_end_date: 5.days.ago
        expect(qono).not_to be_conformant
        expect(qono.conformance_errors).to have_key(:ON10)
      end
    end

    describe "ON12" do
      it "valid" do
        bottom_date = Date.new(2007, 12, 31)
        measure = create :measure,
                  ordernumber: generate(:quota_order_number_id),
                  validity_start_date: bottom_date - 1.day
        qon = create :quota_order_number,
                    quota_order_number_id: measure.ordernumber
        qono = build :quota_order_number_origin,
                     quota_order_number_sid: qon.quota_order_number_sid
        expect(qono).to be_conformant_for(:destroy)
      end

      it "invalid" do
        measure = create :measure,
                  ordernumber: generate(:quota_order_number_id),
                  validity_start_date: 20.days.ago
        qon = create :quota_order_number,
                    quota_order_number_id: measure.ordernumber
        qono = build :quota_order_number_origin,
                     quota_order_number_sid: qon.quota_order_number_sid
        expect(qono).not_to be_conformant_for(:destroy)
        expect(qono.conformance_errors).to have_key(:ON12)
      end
    end

    # describe "ON13" do
    #   it "valid" do
    #     ga = create :geographical_area,
    #                 geographical_code: 1,
    #                 validity_start_date: Date.today.ago(4.years)
    #     qono = build :quota_order_number_origin,
    #                  geographical_area_id: ga.geographical_area_id,
    #                  geographical_area_sid: ga.geographical_area_sid
    #     exclusion = create :quota_order_number_origin_exclusion,
    #                        quota_order_number_origin_sid: qono.quota_order_number_origin_sid
    #     expect(qono).to be_conformant
    #   end

    #   it "invalid" do
    #     ga = create :geographical_area
    #     qono = create :quota_order_number_origin,
    #                   geographical_area_id: ga.geographical_area_id,
    #                   geographical_area_sid: ga.geographical_area_sid
    #     exclusion = create :quota_order_number_origin_exclusion,
    #                        quota_order_number_origin_sid: qono.quota_order_number_origin_sid
    #     expect(qono).to_not be_conformant
    #     expect(qono.conformance_errors).to have_key(:ON13)
    #   end
    # end

    # describe "ON14" do
    #   it "valid" do
    #     group_sid = generate(:sid)
    #     ga = create :geographical_area,
    #                 geographical_code: 1,
    #                 validity_start_date: Date.today.ago(4.years),
    #                 parent_geographical_area_group_sid: group_sid
    #     qono = build :quota_order_number_origin,
    #                  geographical_area_id: ga.geographical_area_id,
    #                  geographical_area_sid: ga.geographical_area_sid
    #     excluded_ga = create :geographical_area,
    #                          parent_geographical_area_group_sid: group_sid
    #     exclusion = create :quota_order_number_origin_exclusion,
    #                        quota_order_number_origin_sid: qono.quota_order_number_origin_sid,
    #                        excluded_geographical_area_sid: excluded_ga.geographical_area_sid
    #     expect(qono).to be_conformant
    #   end

    #   it "invalid" do
    #     ga = create :geographical_area,
    #                 geographical_code: 1,
    #                 parent_geographical_area_group_sid: generate(:sid)
    #     qono = build :quota_order_number_origin,
    #                  geographical_area_id: ga.geographical_area_id,
    #                  geographical_area_sid: ga.geographical_area_sid
    #     excluded_ga = create :geographical_area,
    #                          parent_geographical_area_group_sid: generate(:sid)
    #     exclusion = create :quota_order_number_origin_exclusion,
    #                        quota_order_number_origin_sid: qono.quota_order_number_origin_sid,
    #                        excluded_geographical_area_sid: excluded_ga.geographical_area_sid
    #     expect(qono).to_not be_conformant
    #     expect(qono.conformance_errors).to have_key(:ON14)
    #   end
    # end
  end
end
