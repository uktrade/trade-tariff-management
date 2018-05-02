require 'rails_helper'

describe "Measure Form APIs: Additional codes", type: :request do

  include_context "form_apis_base_context"

  let(:actual_additional_code_1) do
    add_additional_code({
      additional_code: "111",
      additional_code_type_id: "1",
      validity_start_date: 1.year.ago},
      "Alloy tool steel"
    )
  end

  let(:actual_additional_code_2) do
    add_additional_code({
      additional_code: "222",
      additional_code_type_id: "2",
      validity_start_date: 1.year.ago},
      "Chapter 72 of the HTS"
    )
  end

  let(:not_actual_additional_code_3) do
    add_additional_code({
      additional_code: "333",
      additional_code_type_id: "3",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.months.ago},
      "Additional Notes (Taric) to Chapter 72"
    )
  end

  context "Index" do
    before do
      actual_additional_code_1
      actual_additional_code_2
      not_actual_additional_code_3
    end

    it "should return JSON collection of all actual additional_codes" do
      get "/additional_codes.json", headers: headers

      expect(collection.count).to eq(2)

      expecting_additional_code_in_result(0, actual_additional_code_1)
      expecting_additional_code_in_result(1, actual_additional_code_2)
    end

    it "should filter additional_codes by keyword" do
      get "/additional_codes.json", params: { q: "11" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_additional_code_in_result(0, actual_additional_code_1)

      get "/additional_codes.json", params: { q: "Chapter 72" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_additional_code_in_result(0, actual_additional_code_2)
    end

    it "should filter additional_codes by additional_code_type_id" do
      get "/additional_codes.json", params: { additional_code_type_id: "1" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_additional_code_in_result(0, actual_additional_code_1)

      get "/additional_codes.json", params: { additional_code_type_id: "2" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_additional_code_in_result(0, actual_additional_code_2)
    end

    it "should filter additional_codes by keyword and additional_code_type_id at the same time" do
      get "/additional_codes.json", params: { q: "NEGATIVE TEST", additional_code_type_id: "1" },
                                    headers: headers

      expect(collection.count).to eq(0)

      get "/additional_codes.json", params: { q: "Chapter 72", additional_code_type_id: "2" },
                                    headers: headers

      expect(collection.count).to eq(1)
      expecting_additional_code_in_result(0, actual_additional_code_2)
    end
  end

  private

    def add_additional_code(ops={}, description)
      ft = create(:additional_code, ops)
      add_description(ft, description)

      ft
    end

    def add_description(additional_code, description)
      base_ops = {
        additional_code_sid: additional_code.additional_code_sid,
        additional_code: additional_code.additional_code,
        additional_code_type_id: additional_code.additional_code_type_id
      }

      period = create(:additional_code_description_period,
        base_ops.merge(validity_start_date: additional_code.validity_start_date)
      )

      create(:additional_code_description,
        base_ops.merge(
          description: description,
          additional_code_description_period_sid: period.additional_code_description_period_sid
        )
      )
    end

    def expecting_additional_code_in_result(position, additional_code)
      expect(collection[position]["additional_code"]).to be_eql(additional_code.additional_code)
      expect(collection[position]["type_id"]).to be_eql(additional_code.additional_code_type_id)
      expect(collection[position]["description"]).to be_eql(additional_code.description)
    end
end
