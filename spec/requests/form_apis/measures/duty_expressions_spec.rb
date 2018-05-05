require 'rails_helper'

describe "Measure Form APIs: Duty expressions", type: :request do

  include_context "form_apis_base_context"

  let(:actual_duty_expression_99) do
    add_duty_expression({
      duty_expression_id: "99",
      validity_start_date: 1.year.ago},
      "Supplementary unit"
    )
  end

  let(:actual_duty_expression_01) do
    add_duty_expression({
      duty_expression_id: "01",
      validity_start_date: 1.year.ago},
      "% or amount"
    )
  end

  let(:not_actual_duty_expression_03) do
    add_duty_expression({
      duty_expression_id: "03",
      validity_start_date: 1.year.ago,
      validity_end_date: 3.months.ago},
      "The rate is replaced by the levy"
    )
  end

  context "Index" do
    before do
      actual_duty_expression_99
      actual_duty_expression_01
      not_actual_duty_expression_03
    end

    it "should return JSON collection of all actual duty_expressions" do
      get "/duty_expressions.json", headers: headers

      expect(collection.count).to eq(2)

      expecting_duty_expression_in_result(0, actual_duty_expression_01)
      expecting_duty_expression_in_result(1, actual_duty_expression_99)
    end

    it "should filter duty_expressions by keyword" do
      get "/duty_expressions.json", params: { q: "% or amo" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_duty_expression_in_result(0, actual_duty_expression_01)

      get "/duty_expressions.json", params: { q: "99" }, headers: headers

      expect(collection.count).to eq(1)
      expecting_duty_expression_in_result(0, actual_duty_expression_99)
    end
  end

  private

    def add_duty_expression(ops={}, description)
      dt = create(:duty_expression, ops)
      set_description(dt, description)

      dt
    end

    def set_description(duty_expression, description)
      create(:duty_expression_description,
        duty_expression_id: duty_expression.duty_expression_id,
        description: description
      )
    end

    def expecting_duty_expression_in_result(position, duty_expression)
      expect(collection[position]["duty_expression_id"]).to be_eql(
        duty_expression.duty_expression_id
      )
      expect(collection[position]["description"]).to be_eql(duty_expression.description)
      expect(collection[position]["abbreviation"]).to be_eql(duty_expression.abbreviation)
    end
end
