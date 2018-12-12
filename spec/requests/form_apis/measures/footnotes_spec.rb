require 'rails_helper'

describe "Measure Form APIs: Footnotes", type: :request do
  include_context "form_apis_base_context"

  let(:actual_footnote_wr) do
    add_footnote({
      footnote_id: "333",
      footnote_type_id: "WR",
      validity_start_date: 1.year.ago
 },
      "Wine reference footnote")
  end

  let(:actual_footnote_nc) do
    add_footnote({
      footnote_id: "444",
      footnote_type_id: "NC",
      validity_start_date: 1.year.ago
 },
      "Combined Nomenclature footnote")
  end

  let(:not_actual_footnote_c) do
    add_footnote({
      footnote_id: "555",
      footnote_type_id: "TM",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.months.ago
 },
      "Taric Measure footnote")
  end

  context "Index" do
    before do
      actual_footnote_wr
      actual_footnote_nc
      not_actual_footnote_c
    end

    it "should return JSON collection of all actual footnotes" do
      get "/footnotes.json", headers: headers

      expect(collection.count).to eq(2)

      expecting_footnote_in_result(0, actual_footnote_wr)
      expecting_footnote_in_result(1, actual_footnote_nc)
    end

    it "should filter footnotes by keyword" do
      get "/footnotes.json", params: { description: "Combined Nomen" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_footnote_in_result(0, actual_footnote_nc)

      get "/footnotes.json", params: { description: "33" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_footnote_in_result(0, actual_footnote_wr)
    end

    it "should filter footnotes by footnote_type_id" do
      get "/footnotes.json", params: { footnote_type_id: "NC" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_footnote_in_result(0, actual_footnote_nc)

      get "/footnotes.json", params: { footnote_type_id: "WR" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_footnote_in_result(0, actual_footnote_wr)
    end

    it "should filter footnotes by keyword and footnote_type_id at the same time" do
      get "/footnotes.json", params: { footnote_type_id: "NC", description: "Combined No" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_footnote_in_result(0, actual_footnote_nc)

      get "/footnotes.json", params: { footnote_type_id: "NC", description: "NEGATIVE TEST" }, headers: headers

      expect(collection.count).to eq(0)
    end
  end

  private

  def add_footnote(ops = {}, description)
    ft = create(:footnote, ops)
    add_description(ft, description)

    ft
  end

  def add_description(footnote, description)
    desc_record = FootnoteDescription.actual.where(
      footnote_type_id: footnote.footnote_type_id,
      footnote_id: footnote.footnote_id
    ).first

    desc_record.description = description
    desc_record.save
  end

  def expecting_footnote_in_result(position, footnote)
    expect(collection[position]["footnote_id"]).to be_eql(footnote.footnote_id)
    expect(collection[position]["footnote_type_id"]).to be_eql(footnote.footnote_type_id)
    expect(collection[position]["description"]).to be_eql(footnote.description)
  end
end
