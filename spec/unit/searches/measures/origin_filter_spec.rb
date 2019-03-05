require "rails_helper"

describe "Measure search: origin filter" do
  include_context "measures_search_is_or_is_not_context"

  let(:search_key) { "origin" }

  let!(:ae_measure) do
    create(:measure, geographical_area_id: "AE")
  end

  let!(:ag_measure) do
    create(:measure, geographical_area_id: "AG")
  end

  let!(:second_ag_measure) do
    create(:measure, geographical_area_id: "AG")
  end

  describe "Valid Search" do
    it "filters by geographical_area_id with 'is' operator" do
      res = search_results(
        enabled: true,
        operator: 'is',
        value: "AE"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(ae_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'is',
        value: "AG"
      )

      expect(res.count).to be_eql(2)

      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).to include(ag_measure.measure_sid)
      expect(measure_sids).to include(second_ag_measure.measure_sid)
      expect(measure_sids).not_to include(ae_measure.measure_sid)
    end

    it "filters by geographical_area_id with 'is_not' operator" do
      res = search_results(
        enabled: true,
        operator: 'is_not',
        value: "AE"
      )

      expect(res.count).to be_eql(2)
      expect(res.map(&:measure_sid)).not_to include(ae_measure.measure_sid)
    end
  end
end
