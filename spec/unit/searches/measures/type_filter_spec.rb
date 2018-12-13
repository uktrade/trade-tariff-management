require "rails_helper"

describe "Measure search: type filter" do
  include_context "measures_search_is_or_is_not_context"

  let(:search_key) { "type" }

  let(:type_143_measure) do
    create(:measure, measure_type_id: "143")
  end

  let(:type_481_measure) do
    create(:measure, measure_type_id: "481")
  end

  let(:second_type_481_measure) do
    create(:measure, measure_type_id: "481")
  end

  before do
    type_143_measure
    type_481_measure
    second_type_481_measure
  end

  describe "Valid Search" do
    it "filters by measure_type_id with 'is' operator" do
      res = search_results(
        enabled: true,
        operator: 'is',
        value: "143"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(type_143_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'is',
        value: "481"
      )

      expect(res.count).to be_eql(2)

      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).to include(type_481_measure.measure_sid)
      expect(measure_sids).to include(second_type_481_measure.measure_sid)
      expect(measure_sids).not_to include(type_143_measure.measure_sid)
    end

    it "filters by measure_type_id with 'is_not' operator" do
      res = search_results(
        enabled: true,
        operator: 'is_not',
        value: "143"
      )

      expect(res.count).to be_eql(2)
      expect(res.map(&:measure_sid)).not_to include(type_143_measure.measure_sid)
    end
  end
end
