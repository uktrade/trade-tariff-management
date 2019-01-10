require 'rails_helper'

shared_context "form_apis_regulations_base_context" do
  let(:actual_base_regulation_i9602220) do
    add_base_regulation("I9602220", "New classification 2005 (01/08/1996)")
  end

  let(:not_actual_base_regulation_r9335816) do
    add_base_regulation("R9335816", "RO - K (01/01/1994)", 3.months.ago)
  end

  let(:actual_modification_regulation_r9713280) do
    add_modification_regulation("R9713280", "Measure 103 (Chapter 10) (10/07/1997)")
  end

  let(:not_actual_modification_regulation_r9713560) do
    add_modification_regulation("R9713560", "K: PHC, BG, RO (CHAP.10, 11) (19/07/1997)", 3.months.ago)
  end

  context "Index" do
    before do
      actual_base_regulation_i9602220
      not_actual_base_regulation_r9335816
      actual_modification_regulation_r9713280
      not_actual_modification_regulation_r9713560
    end

    it "returns JSON collection of all actual regulation groups" do
      get target_url, headers: headers

      expect(collection.count).to eq(2)

      expecting_regulation_in_result(0, actual_base_regulation_i9602220)
      expecting_regulation_in_result(1, actual_modification_regulation_r9713280)
    end

    it "filters regulation groups by keyword" do
      get target_url, params: { q: "New classification 2005" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_regulation_in_result(0, actual_base_regulation_i9602220)

      get target_url, params: { q: "R971328" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_regulation_in_result(0, actual_modification_regulation_r9713280)
    end
  end

  private

  def expecting_regulation_in_result(position, regulation)
    expect(collection[position]["regulation_id"]).to be_eql(regulation.public_send(regulation.primary_key[0]))
    expect(collection[position]["role"]).to be_eql(regulation.public_send(regulation.primary_key[1]))
    expect(collection[position]["description"]).to be_eql(information_text(regulation))
  end

  def add_base_regulation(regulation_id, description, effective_end_date = nil)
    create(:base_regulation, regulation_base_ops(description, effective_end_date).merge(
                               base_regulation_id: regulation_id
    ))
  end

  def add_modification_regulation(regulation_id, description, effective_end_date = nil)
    create(:modification_regulation, regulation_base_ops(description, effective_end_date).merge(
                                       modification_regulation_id: regulation_id
    ))
  end

  def regulation_base_ops(description, effective_end_date = nil)
    {
      replacement_indicator: 0,
      information_text: description,
      validity_start_date: 1.year.ago,
      effective_end_date: effective_end_date
    }
  end
end
