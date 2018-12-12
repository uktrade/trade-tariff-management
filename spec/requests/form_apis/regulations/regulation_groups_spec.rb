require 'rails_helper'

describe "Regulation Form APIs: Regulation groups", type: :request do
  include_context "form_apis_base_context"

  let(:actual_group_apl) do
    add_group("APL", "Unit price, standard import value")
  end

  let(:actual_group_prf) do
    add_group("PRF", "Preferential duty")
  end

  let(:not_actual_group_apl) do
    add_group("CIT", "CITES", 3.months.ago)
  end

  context "Index" do
    before do
      actual_group_apl
      actual_group_prf
      not_actual_group_apl
    end

    it "should return JSON collection of all actual regulation groups" do
      get "/regulation_form_api/regulation_groups.json", headers: headers

      expect(collection.count).to eq(2)

      expecting_group_in_result(0, actual_group_apl)
      expecting_group_in_result(1, actual_group_prf)
    end

    it "should filter regulation groups by keyword" do
      get "/regulation_form_api/regulation_groups.json", params: { q: "Unit price, standard" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_group_in_result(0, actual_group_apl)

      get "/regulation_form_api/regulation_groups.json", params: { q: "PRF" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_group_in_result(0, actual_group_prf)
    end
  end

  private

  def expecting_group_in_result(position, group)
    expect(collection[position]["regulation_group_id"]).to be_eql(group.regulation_group_id)
    expect(collection[position]["description"]).to be_eql(group.description)
  end

  def add_group(regulation_group_id, description, validity_end_date = nil)
    r_group = create(:regulation_group, regulation_group_id: regulation_group_id,
                                        validity_start_date: 1.year.ago,
                                        validity_end_date: validity_end_date)

    create(:regulation_group_description, regulation_group_id: r_group.regulation_group_id,
                                          description: description)

    r_group
  end
end
