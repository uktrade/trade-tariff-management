require 'rails_helper'

describe "Measure Form APIs: Monetary units", type: :request do

  include_context "form_apis_base_context"

  let(:actual_monetary_unit_x) do
    add_monetary_unit({
      monetary_unit_code: "X",
      validity_start_date: 1.year.ago},
      "Wine reference certificate type"
    )
  end

  let(:actual_monetary_unit_y) do
    add_monetary_unit({
      monetary_unit_code: "Y",
      validity_start_date: 1.year.ago},
      "Combined Nomenclature certificate type"
    )
  end

  let(:not_actual_monetary_unit_z) do
    add_monetary_unit({
      monetary_unit_code: "Z",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.months.ago},
      "Taric Measure certificate type"
    )
  end

  context "Index" do
    before do
      actual_monetary_unit_x
      actual_monetary_unit_y
      not_actual_monetary_unit_z
    end

    it "should return JSON collection of all actual monetary_units" do
      get "/monetary_units.json", headers: headers

      expect(collection.count).to eq(2)

      expecting_monetary_unit_in_result(0, actual_monetary_unit_x)
      expecting_monetary_unit_in_result(1, actual_monetary_unit_y)
    end

    it "should filter monetary_units by keyword" do
      get "/monetary_units.json", params: { q: "Combined Nomen" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_monetary_unit_in_result(0, actual_monetary_unit_y)

      get "/monetary_units.json", params: { q: "X" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_monetary_unit_in_result(0, actual_monetary_unit_x)
    end
  end

  private

    def add_monetary_unit(ops={}, description)
      mu = create(:monetary_unit, :with_description, ops)
      set_description(mu, description)

      mu
    end

    def set_description(monetary_unit, description)
      desc = MonetaryUnitDescription.where(
        monetary_unit_code: monetary_unit.monetary_unit_code
      ).first

      desc.description = description
      desc.save
    end

    def expecting_monetary_unit_in_result(position, monetary_unit)
      expect(collection[position]["monetary_unit_code"]).to be_eql(monetary_unit.monetary_unit_code)
      expect(collection[position]["description"]).to be_eql(monetary_unit.description)
    end
end
