require 'rails_helper'

describe "Measure Form APIs: Additional codes", type: :request do

  include_context "form_apis_base_context"

  let(:actual_additional_code_1) do
    create(:additional_code,
      additional_code: "111",
      additional_code_type_id: "1",
      validity_start_date: 1.year.ago
    )
  end

  let(:actual_additional_code_2) do
    create(:additional_code,
      additional_code: "222",
      additional_code_type_id: "2",
      validity_start_date: 1.year.ago
    )
  end

  let(:not_actual_additional_code_3) do
    create(:additional_code,
      additional_code: "333",
      additional_code_type_id: "3",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.months.ago
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

      get "/additional_codes.json", params: { q: "22" }, headers: headers

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
      create(
        :additional_code_description,
        additional_code: additional_code.additional_code,
        additional_code_type_id: additional_code.additional_code_type_id,
        description: description
      )
    end

    def expecting_additional_code_in_result(position, additional_code)
      expect(collection[position]["additional_code_id"]).to be_eql(
        additional_code.additional_code_id
      )
    end
end
