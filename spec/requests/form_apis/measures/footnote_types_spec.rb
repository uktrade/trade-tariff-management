require 'rails_helper'

describe "Measure Form APIs: Footnote types", type: :request do
  include_context "form_apis_base_context"

  let(:actual_footnote_type_wr) do
    add_footnote_type({
      footnote_type_id: "WR",
      validity_start_date: 1.year.ago
 },
      "Wine reference")
  end

  let(:actual_footnote_type_nc) do
    add_footnote_type({
      footnote_type_id: "NC",
      validity_start_date: 1.year.ago
 },
      "Combined Nomenclature")
  end

  let(:not_actual_footnote_type_c) do
    add_footnote_type({
      footnote_type_id: "TM",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.months.ago
 },
      "Taric Measure")
  end

  context "Index" do
    before do
      actual_footnote_type_wr
      actual_footnote_type_nc
      not_actual_footnote_type_c
    end

    it "should return JSON collection of all actual footnote types" do
      get "/footnote_types.json", headers: headers

      expect(collection.count).to eq(2)

      expecting_footnote_type_in_result(0, actual_footnote_type_nc)
      expecting_footnote_type_in_result(1, actual_footnote_type_wr)
    end

    it "should filter footnote types by keyword" do
      get "/footnote_types.json", params: { q: "Combined Nomen" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_footnote_type_in_result(0, actual_footnote_type_nc)

      get "/footnote_types.json", params: { q: "WR" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_footnote_type_in_result(0, actual_footnote_type_wr)
    end
  end

  private

  def add_footnote_type(ops = {}, description)
    ft = create(:footnote_type, ops)
    add_description(ft, description)

    ft
  end

  def add_description(footnote_type, description)
    create(
      :footnote_type_description,
      footnote_type_id: footnote_type.footnote_type_id,
      description: description
    )
  end

  def expecting_footnote_type_in_result(position, footnote_type)
    expect(collection[position]["footnote_type_id"]).to be_eql(footnote_type.footnote_type_id)
    expect(collection[position]["description"]).to be_eql(footnote_type.description)
  end
end
