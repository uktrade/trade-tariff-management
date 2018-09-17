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
        expect(qono2).to_not be_conformant
        expect(qono2.conformance_errors).to have_key(:ON5)
      end
    end
  end
end
