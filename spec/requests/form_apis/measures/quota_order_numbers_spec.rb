require 'rails_helper'

describe "Measure Form APIs: Quota order numbers", type: :request do
  include_context "form_apis_base_context"

  let(:actual_quota_order_number_1) do
    create(:quota_order_number,
      quota_order_number_id: "111111",
      validity_start_date: 1.year.ago)
  end

  let(:actual_quota_order_number_2) do
    create(:quota_order_number,
      quota_order_number_id: "222222",
      validity_start_date: 1.year.ago)
  end

  let(:not_actual_quota_order_number_3) do
    create(:quota_order_number,
      quota_order_number_id: "333333",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.months.ago)
  end

  context "Index" do
    before do
      actual_quota_order_number_1
      actual_quota_order_number_2
      not_actual_quota_order_number_3
    end

    it "should return JSON collection of all actual quota_order_numbers" do
      get "/quota_order_numbers.json", headers: headers

      expect(collection.count).to eq(2)

      expecting_quota_order_number_in_result(0, actual_quota_order_number_1)
      expecting_quota_order_number_in_result(1, actual_quota_order_number_2)
    end

    it "should filter quota_order_numbers by keyword" do
      get "/quota_order_numbers.json", params: { q: "11" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_quota_order_number_in_result(0, actual_quota_order_number_1)

      get "/quota_order_numbers.json", params: { q: "22" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_quota_order_number_in_result(0, actual_quota_order_number_2)
    end
  end

  private

  def expecting_quota_order_number_in_result(position, quota_order_number)
    expect(collection[position]["quota_order_number_id"]).to be_eql(
      quota_order_number.quota_order_number_id
    )
  end
end
