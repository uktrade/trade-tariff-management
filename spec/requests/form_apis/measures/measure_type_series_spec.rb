require 'rails_helper'

describe "Measure Form APIs: Measure type series", type: :request do

  include_context "form_apis_base_context"

  let(:actual_measure_type_series_a) do
    add_measure_type_series({
      measure_type_series_id: "A",
      validity_start_date: 1.year.ago},
      "Importation and/or exportation prohibited"
    )
  end

  let(:actual_measure_type_series_b) do
    add_measure_type_series({
      measure_type_series_id: "B",
      validity_start_date: 1.year.ago},
      "Entry into free circulation or exportation subject to conditions"
    )
  end

  let(:not_actual_measure_type_series_c) do
    add_measure_type_series({
      measure_type_series_id: "C",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.months.ago},
      "Applicable duty"
    )
  end

  context "Index" do
    before do
      actual_measure_type_series_a
      actual_measure_type_series_b
      not_actual_measure_type_series_c
    end

    it "should return JSON collection of all actual measure_type_series" do
      get "/measure_type_series.json", headers: headers

      expect(collection.count).to eq(2)

      expecting_measure_type_series_in_result(0, actual_measure_type_series_a)
      expecting_measure_type_series_in_result(1, actual_measure_type_series_b)
    end

    it "should filter measure_type_series by keyword" do
      get "/measure_type_series.json", params: { q: "Importation and" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_measure_type_series_in_result(0, actual_measure_type_series_a)

      get "/measure_type_series.json", params: { q: "Entry into free" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_measure_type_series_in_result(0, actual_measure_type_series_b)
    end
  end

  private

    def add_measure_type_series(ops={}, description)
      mt = create(:measure_type_series, ops)
      add_description(mt, description)

      mt
    end

    def add_description(measure_type_series, description)
      create(
        :measure_type_series_description,
        measure_type_series_id: measure_type_series.measure_type_series_id,
        description: description
      )
    end

    def expecting_measure_type_series_in_result(position, measure_type_series)
      expect(collection[position]["measure_type_series_id"]).to be_eql(measure_type_series.measure_type_series_id)
      expect(collection[position]["description"]).to be_eql(measure_type_series.description)
      expect(date_to_format(collection[position]["validity_start_date"])).to be_eql(
        date_to_format(measure_type_series.validity_start_date)
      )
    end
end
