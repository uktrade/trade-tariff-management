require 'rails_helper'

describe "Measure Form APIs: Measure condition codes", type: :request do

  include_context "form_apis_base_context"

  let(:actual_measure_condition_code_x) do
    add_measure_condition_code({
      condition_code: "X",
      validity_start_date: 1.year.ago},
      "Wine reference certificate type"
    )
  end

  let(:actual_measure_condition_code_y) do
    add_measure_condition_code({
      condition_code: "Y",
      validity_start_date: 1.year.ago},
      "Combined Nomenclature certificate type"
    )
  end

  let(:not_actual_measure_condition_code_z) do
    add_measure_condition_code({
      condition_code: "Z",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.months.ago},
      "Taric Measure certificate type"
    )
  end

  context "Index" do
    before do
      actual_measure_condition_code_x
      actual_measure_condition_code_y
      not_actual_measure_condition_code_z
    end

    it "should return JSON collection of all actual measure_condition_codes" do
      get "/measure_condition_codes.json", headers: headers

      expect(collection.count).to eq(2)

      expecting_measure_condition_code_in_result(0, actual_measure_condition_code_x)
      expecting_measure_condition_code_in_result(1, actual_measure_condition_code_y)
    end

    it "should filter measure_condition_codes by keyword" do
      get "/measure_condition_codes.json", params: { q: "Combined Nomen" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_measure_condition_code_in_result(0, actual_measure_condition_code_y)

      get "/measure_condition_codes.json", params: { q: "X" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_measure_condition_code_in_result(0, actual_measure_condition_code_x)
    end
  end

  private

    def add_measure_condition_code(ops={}, description)
      ct = create(:measure_condition_code, ops)
      add_description(ct, description)

      ct
    end

    def add_description(measure_condition_code, description)
      create(:measure_condition_code_description,
        condition_code: measure_condition_code.condition_code,
        description: description
      )
    end

    def expecting_measure_condition_code_in_result(position, measure_condition_code)
      expect(collection[position]["condition_code"]).to be_eql(measure_condition_code.condition_code)
      expect(collection[position]["description"]).to be_eql(measure_condition_code.description)
    end
end
