require "rails_helper"

describe "Measure search: status filter" do

  include_context "measures_search_is_or_is_not_context"

  let(:search_key) { "status" }

  let(:draft_incomplete_measure) do
    create(:measure, status: "draft_incomplete")
  end

  let(:ready_for_approval_measure) do
    create(:measure, status: "ready_for_approval")
  end

  let(:second_ready_for_approval_measure) do
    create(:measure, status: "ready_for_approval")
  end

  before do
    draft_incomplete_measure
    ready_for_approval_measure
    second_ready_for_approval_measure
  end

  describe "Valid Search" do
    it "should filter by status with 'is' operator" do
      res = search_results(
        enabled: true,
        operator: 'is',
        value: "draft_incomplete"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(draft_incomplete_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'is',
        value: "ready_for_approval"
      )

      expect(res.count).to be_eql(2)

      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).to include(ready_for_approval_measure.measure_sid)
      expect(measure_sids).to include(second_ready_for_approval_measure.measure_sid)
      expect(measure_sids).not_to include(draft_incomplete_measure.measure_sid)
    end

    it "should filter by status with 'is_not' operator" do
      res = search_results(
        enabled: true,
        operator: 'is_not',
        value: "draft_incomplete"
      )

      expect(res.count).to be_eql(2)
      expect(res.map(&:measure_sid)).not_to include(draft_incomplete_measure.measure_sid)
    end
  end
end
