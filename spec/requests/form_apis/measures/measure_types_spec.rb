require 'rails_helper'

describe "Measure Form APIs: Measure types", type: :request do
  include_context "form_apis_base_context"

  let(:actual_measure_type_277) do
    add_measure_type({
      measure_type_id: "277",
      measure_type_series_id: "A",
      validity_start_date: 1.year.ago,
      measure_type_acronym: "TI1"
 },
      "Import prohibition")
  end

  let(:actual_measure_type_481) do
    add_measure_type({
      measure_type_id: "481",
      measure_type_series_id: "A",
      validity_start_date: 1.year.ago,
      measure_type_acronym: "DTK"
 },
      "Declaration of subheading submitted to restrictions (import)")
  end

  let(:actual_measure_type_106) do
    add_measure_type({
      measure_type_id: "106",
      measure_type_series_id: "C",
      validity_start_date: 1.year.ago,
      measure_type_acronym: "WFR"
 },
      "Customs Union Duty")
  end

  let(:not_actual_measure_type_105) do
    add_measure_type({
      measure_type_id: "105",
      measure_type_series_id: "C",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.months.ago,
      measure_type_acronym: "MR"
 },
      "Non preferential duty under end-use")
  end

  context "Index" do
    before do
      actual_measure_type_277
      actual_measure_type_481
      actual_measure_type_106
      not_actual_measure_type_105
    end

    it "should return JSON collection of all actual measure_types" do
      get "/measure_types.json", headers: headers

      expect(collection.count).to eq(3)

      expecting_measure_type_in_result(0, actual_measure_type_106)
      expecting_measure_type_in_result(1, actual_measure_type_277)
      expecting_measure_type_in_result(2, actual_measure_type_481)
    end

    it "should filter measure_types by keyword" do
      get "/measure_types.json", params: { q: "Declaration of subheading submitted" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_measure_type_in_result(0, actual_measure_type_481)

      get "/measure_types.json", params: { q: "27" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_measure_type_in_result(0, actual_measure_type_277)
    end

    it "should filter measure_types by measure_type_series_id" do
      get "/measure_types.json", params: { measure_type_series_id: "C" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_measure_type_in_result(0, actual_measure_type_106)

      get "/measure_types.json", params: { measure_type_series_id: "A" }, headers: headers

      expect(collection.count).to eq(2)
      expecting_measure_type_in_result(0, actual_measure_type_277)
      expecting_measure_type_in_result(1, actual_measure_type_481)
    end

    it "should filter measure_types by keyword and measure_type_series_id at the same time" do
      get "/measure_types.json", params: { q: "481", measure_type_series_id: "C" }, headers: headers

      expect(collection.count).to eq(0)

      get "/measure_types.json", params: { q: "106", measure_type_series_id: "C" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_measure_type_in_result(0, actual_measure_type_106)
    end
  end

  private

  def add_measure_type(ops = {}, description)
    mt = create(:measure_type, ops)
    add_description(mt, description)

    mt
  end

  def add_description(measure_type, description)
    create(
      :measure_type_description,
      measure_type_id: measure_type.measure_type_id,
      description: description
    )
  end

  def expecting_measure_type_in_result(position, measure_type)
    expect(collection[position]["measure_type_id"]).to be_eql(measure_type.measure_type_id)
    expect(collection[position]["measure_type_series_id"]).to be_eql(measure_type.measure_type_series_id)
    expect(collection[position]["measure_type_acronym"]).to be_eql(measure_type.measure_type_acronym)
    expect(collection[position]["description"]).to be_eql(measure_type.description)
    expect(date_to_format(collection[position]["validity_start_date"])).to be_eql(
      date_to_format(measure_type.validity_start_date)
    )
  end

  def date_to_format(date_in_string)
    date_in_string.to_date
                  .strftime("%d/%m/%Y")
  end
end
