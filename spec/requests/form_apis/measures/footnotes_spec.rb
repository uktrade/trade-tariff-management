require 'rails_helper'

describe "Measure Form APIs: Footnotes", type: :request do

  include_context "form_apis_base_context"

  let(:actual_footnote_wr) do
    add_footnote({
      footnote_id: "333",
      footnote_type_id: "WR",
      validity_start_date: 1.year.ago},
      "Wine reference footnote"
    )
  end

  let(:actual_footnote_nc) do
    add_footnote({
      footnote_id: "444",
      footnote_type_id: "NC",
      validity_start_date: 1.year.ago},
      "Combined Nomenclature footnote"
    )
  end

  let(:not_actual_footnote_c) do
    add_footnote({
      footnote_id: "555",
      footnote_type_id: "TM",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.months.ago},
      "Taric Measure footnote"
    )
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

      expecting_footnote_in_result(0, actual_footnote_nc)
      expecting_footnote_in_result(1, actual_footnote_wr)
    end

    # it "should filter footnotes by keyword" do
    #   get "/footnotes.json", params: { q: "Combined Nomen" }, headers: headers

    #   expect(collection.count).to eq(1)
    #   expecting_footnote_in_result(0, actual_footnote_nc)

    #   get "/footnotes.json", params: { q: "WR" }, headers: headers

    #   expect(collection.count).to eq(1)
    #   expecting_footnote_in_result(0, actual_footnote_wr)
    # end
  end

  private

    def add_footnote(ops={}, description)
      ft = create(:footnote, ops)
      add_description(ft, description)

      ft
    end

    def add_description(footnote, description)
      create(
        :footnote_description,
        footnote_type_id: footnote.footnote_type_id,
        footnote_id: footnote.footnote_id,
        description: description
      )
    end

    def expecting_footnote_in_result(position, footnote)
      expect(collection[position]["footnote_id"]).to be_eql(footnote.footnote_id)
      expect(collection[position]["footnote_type_id"]).to be_eql(footnote.footnote_type_id)
      expect(collection[position]["description"]).to be_eql(footnote.description)
    end
end
