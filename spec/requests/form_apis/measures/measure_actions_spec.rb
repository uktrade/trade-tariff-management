require 'rails_helper'

describe "Measure Form APIs: Measure actions", type: :request do

  include_context "form_apis_base_context"

  let(:actual_measure_action_x) do
    add_measure_action({
      action_code: "X",
      validity_start_date: 1.year.ago},
      "Wine reference certificate type"
    )
  end

  let(:actual_measure_action_y) do
    add_measure_action({
      action_code: "Y",
      validity_start_date: 1.year.ago},
      "Combined Nomenclature certificate type"
    )
  end

  let(:not_actual_measure_action_z) do
    add_measure_action({
      action_code: "Z",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.months.ago},
      "Taric Measure certificate type"
    )
  end

  context "Index" do
    before do
      actual_measure_action_x
      actual_measure_action_y
      not_actual_measure_action_z
    end

    it "should return JSON collection of all actual measure_actions" do
      get "/measure_actions.json", headers: headers

      expect(collection.count).to eq(2)

      expecting_measure_action_in_result(0, actual_measure_action_x)
      expecting_measure_action_in_result(1, actual_measure_action_y)
    end

    it "should filter measure_actions by keyword" do
      get "/measure_actions.json", params: { q: "Combined Nomen" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_measure_action_in_result(0, actual_measure_action_y)

      get "/measure_actions.json", params: { q: "X" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_measure_action_in_result(0, actual_measure_action_x)
    end
  end

  private

    def add_measure_action(ops={}, description)
      ct = create(:measure_action, ops)
      add_description(ct, description)

      ct
    end

    def add_description(measure_action, description)
      create(:measure_action_description,
        action_code: measure_action.action_code,
        description: description
      )
    end

    def expecting_measure_action_in_result(position, measure_action)
      expect(collection[position]["action_code"]).to be_eql(measure_action.action_code)
      expect(collection[position]["description"]).to be_eql(measure_action.description)
    end
end
