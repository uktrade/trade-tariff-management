require 'rails_helper'

describe "Measure Form APIs: Measurement units", type: :request do

  include_context "form_apis_base_context"

  let(:actual_measurement_unit_wat) do
    add_measurement_unit({
      measurement_unit_code: "WAT",
      validity_start_date: 1.year.ago},
      "Number of Watt",
      "Watt"
    )
  end

  let(:actual_measurement_unit_cct) do
    add_measurement_unit({
      measurement_unit_code: "CCT",
      validity_start_date: 1.year.ago},
      "Carrying capacity in metric tonnes",
      "ct/l"
    )
  end

  let(:not_actual_measurement_unit_mtr) do
    add_measurement_unit({
      measurement_unit_code: "MTR",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.months.ago},
      "Metre",
      "m"
    )
  end

  context "Index" do
    before do
      actual_measurement_unit_wat
      actual_measurement_unit_cct
      not_actual_measurement_unit_mtr
    end

    it "should return JSON collection of all actual measurement_units" do
      get "/measurement_units.json", headers: headers

      expect(collection.count).to eq(2)

      expecting_measurement_unit_in_result(0, actual_measurement_unit_cct)
      expecting_measurement_unit_in_result(1, actual_measurement_unit_wat)
    end

    it "should filter measurement_units by keyword" do
      get "/measurement_units.json", params: { q: "Carrying capacity in" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_measurement_unit_in_result(0, actual_measurement_unit_cct)

      get "/measurement_units.json", params: { q: "WAT" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_measurement_unit_in_result(0, actual_measurement_unit_wat)
    end
  end

  private

    def add_measurement_unit(ops={}, description, abbreviation)
      mu = create(:measurement_unit, :with_description, ops)
      set_description(mu, description)
      set_abbreviation(mu, abbreviation)

      mu
    end

    def set_description(measurement_unit, description)
      desc = MeasurementUnitDescription.where(
        measurement_unit_code: measurement_unit.measurement_unit_code
      ).first

      desc.description = description
      desc.save
    end

    def set_abbreviation(measurement_unit, abbreviation)
      create(:measurement_unit_abbreviation,
        measurement_unit_code: measurement_unit.measurement_unit_code,
        abbreviation: abbreviation
      )
    end

    def expecting_measurement_unit_in_result(position, measurement_unit)
      expect(collection[position]["measurement_unit_code"]).to be_eql(measurement_unit.measurement_unit_code)
      expect(collection[position]["description"]).to be_eql(measurement_unit.description)
      expect(collection[position]["abbreviation"]).to be_eql(measurement_unit.abbreviation)
    end
end
