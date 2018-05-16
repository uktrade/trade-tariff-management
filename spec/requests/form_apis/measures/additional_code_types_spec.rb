require 'rails_helper'

describe "Measure Form APIs: Additional code types", type: :request do

  include_context "form_apis_base_context"

  let(:measure_type_277) do
    create(:measure_type,
      measure_type_id: "277",
      measure_type_series_id: "A",
      validity_start_date: 1.year.ago,
      measure_type_acronym: "TI1"
    )
  end

  let(:measure_type_488) do
    create(:measure_type,
      measure_type_id: "488",
      measure_type_series_id: "A",
      validity_start_date: 1.year.ago,
      measure_type_acronym: "DTK"
    )
  end

  let(:actual_additional_code_type_1) do
    add_additional_code_type({
      additional_code_type_id: "Y",
      validity_start_date: 1.year.ago},
      measure_type_277,
      "Anti-dumping/countervailing"
    )
  end

  let(:actual_additional_code_type_2) do
    add_additional_code_type({
      additional_code_type_id: "X",
      validity_start_date: 1.year.ago},
      measure_type_488,
      "Reference prices fishery products"
    )
  end

  let(:not_actual_additional_code_type_3) do
    add_additional_code_type({
      additional_code_type_id: "2",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.months.ago},
      measure_type_488,
      "Tariff preference"
    )
  end

  context "Index" do
    before do
      measure_type_277
      measure_type_488
      actual_additional_code_type_1
      actual_additional_code_type_2
      not_actual_additional_code_type_3
    end

    it "should return actual additional_code_types only" do
      get "/additional_code_types.json", params: { measure_type_id: "488" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_additional_code_type_in_result(0, actual_additional_code_type_2)
    end

    it "should filter additional_code_types by measure_type_id" do
      get "/additional_code_types.json", params: { measure_type_id: "277" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_additional_code_type_in_result(0, actual_additional_code_type_1)

      get "/additional_code_types.json", params: { measure_type_id: "488" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_additional_code_type_in_result(0, actual_additional_code_type_2)
    end

    it "should filter additional_code_types by keyword and measure_type_id at the same time" do
      get "/additional_code_types.json", params: { q: "Y", measure_type_id: "277" },
                                         headers: headers

      expect(collection.count).to eq(1)
      expecting_additional_code_type_in_result(0, actual_additional_code_type_1)

      get "/additional_code_types.json", params: { q: "Ref", measure_type_id: "488" },
                                         headers: headers

      expect(collection.count).to eq(1)
      expecting_additional_code_type_in_result(0, actual_additional_code_type_2)
    end
  end

  private

    def add_additional_code_type(ops={}, measure_type, description)
      ac_type = create(:additional_code_type, ops)
      add_description(ac_type, description)
      add_additional_code_type_measure_type(ac_type, measure_type)

      ac_type
    end

    def add_description(additional_code_type, description)
      create(:additional_code_type_description,
        additional_code_type_id: additional_code_type.additional_code_type_id,
        description: description
      )
    end

    def add_additional_code_type_measure_type(additional_code_type, measure_type)
      create(:additional_code_type_measure_type,
        additional_code_type_id: additional_code_type.additional_code_type_id,
        measure_type_id: measure_type.measure_type_id,
        validity_start_date: additional_code_type.validity_start_date
      )
    end

    def expecting_additional_code_type_in_result(position, additional_code_type)
      expect(collection[position]["additional_code_type_id"]).to be_eql(
        additional_code_type.additional_code_type_id
      )
      expect(collection[position]["description"]).to be_eql(additional_code_type.description)
    end
end
