require 'rails_helper'

describe "Measure Form APIs: Measurement unit qualifiers", type: :request do

  include_context "form_apis_base_context"

  let(:actual_measurement_unit_qualifier_z) do
    add_measurement_unit_qualifier({
      measurement_unit_qualifier_code: "Z",
      validity_start_date: 1.year.ago},
      "per 1% by weight of sucrose"
    )
  end

  let(:actual_measurement_unit_qualifier_g) do
    add_measurement_unit_qualifier({
      measurement_unit_qualifier_code: "G",
      validity_start_date: 1.year.ago},
      "Gross"
    )
  end

  let(:not_actual_measurement_unit_qualifier_b) do
    add_measurement_unit_qualifier({
      measurement_unit_qualifier_code: "B",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.months.ago},
      "per flask"
    )
  end

  context "Index" do
    before do
      actual_measurement_unit_qualifier_z
      actual_measurement_unit_qualifier_g
      not_actual_measurement_unit_qualifier_b
    end

    it "should return JSON collection of all actual measurement_unit_qualifiers" do
      get "/measurement_unit_qualifiers.json", headers: headers

      expect(collection.count).to eq(2)

      expecting_measurement_unit_qualifier_in_result(0, actual_measurement_unit_qualifier_g)
      expecting_measurement_unit_qualifier_in_result(1, actual_measurement_unit_qualifier_z)
    end

    it "should filter measurement_unit_qualifiers by keyword" do
      get "/measurement_unit_qualifiers.json", params: { q: "Gros" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_measurement_unit_qualifier_in_result(0, actual_measurement_unit_qualifier_g)

      get "/measurement_unit_qualifiers.json", params: { q: "Z" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_measurement_unit_qualifier_in_result(0, actual_measurement_unit_qualifier_z)
    end
  end

  private

    def add_measurement_unit_qualifier(ops={}, description)
      muq = create(:measurement_unit_qualifier, ops)
      set_description(muq, description)

      muq
    end

    def set_description(measurement_unit_qualifier, description)
      create(:measurement_unit_qualifier_description,
        measurement_unit_qualifier_code: measurement_unit_qualifier.measurement_unit_qualifier_code,
        description: description
      )
    end

    def expecting_measurement_unit_qualifier_in_result(position, measurement_unit_qualifier)
      expect(collection[position]["measurement_unit_qualifier_code"]).to be_eql(
        measurement_unit_qualifier.measurement_unit_qualifier_code
      )
      expect(collection[position]["description"]).to be_eql(measurement_unit_qualifier.description)
    end
end
