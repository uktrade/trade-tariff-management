require "rails_helper"

describe "Measure search: status filter" do

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
        operator: 'is',
        value: "draft_incomplete"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(draft_incomplete_measure.measure_sid)

      res = search_results(
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
        operator: 'is_not',
        value: "draft_incomplete"
      )

      expect(res.count).to be_eql(2)
      expect(res.map(&:measure_sid)).not_to include(draft_incomplete_measure.measure_sid)
    end
  end

  describe "Invalid Search" do
    it "should not filter by status with 'is' if value blank" do
      res = search_results(
        operator: 'is'
      )

      expect(res.count).to be_eql(3)
    end

    it "should not filter by status with 'is_not' if value blank" do
      res = search_results(
        operator: 'is_not'
      )

      expect(res.count).to be_eql(3)
    end

    it "should not filter by status with blank ops provided" do
      res = search_results({})

      expect(res.count).to be_eql(3)
    end
  end

  private

    def search_results(ops)
      ::Measures::Search.new(
        status: ops
      ).results
       .to_a
    end
end
