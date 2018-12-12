require "rails_helper"

describe "Measure search: commodity code filter" do
  include_context "measures_search_is_or_is_not_context"

  let(:search_key) { "commodity_code" }

  let(:a_measure) do
    create(:measure, goods_nomenclature_item_id: "3333333333")
  end

  let(:b_measure) do
    create(:measure, goods_nomenclature_item_id: "3333444444")
  end

  let(:c_measure) do
    create(:measure, goods_nomenclature_item_id: "5555555555")
  end

  before do
    a_measure
    b_measure
    c_measure
  end

  describe "Valid Search" do
    it "should filter by commodity_code with operator" do
      #
      # 'is' filter
      #
      res = search_results(
        enabled: true,
        operator: 'is',
        value: "3333333333"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(a_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'is',
        value: "5555555555"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(c_measure.measure_sid)

      #
      # 'is_not' filter
      #
      res = search_results(
        enabled: true,
        operator: 'is_not',
        value: "3333444444"
      )

      expect(res.count).to be_eql(2)
      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).not_to include(b_measure.measure_sid)

      #
      # 'starts_with' filter
      #
      res = search_results(
        enabled: true,
        operator: 'starts_with',
        value: "3333"
      )

      expect(res.count).to be_eql(2)
      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).not_to include(c_measure.measure_sid)

      #
      # 'is_not_unspecified' filter
      #
      res = search_results(
        enabled: true,
        operator: 'is_not_unspecified'
      )

      expect(res.count).to be_eql(3)
    end
  end
end
