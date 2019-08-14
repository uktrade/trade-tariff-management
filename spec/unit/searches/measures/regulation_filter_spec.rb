require "rails_helper"

describe "Measure search: regulation filter" do
  include_context "measures_search_base_context"

  let(:search_key) { "regulation" }

  let!(:a_measure) do
    set_searchable_jsonb_data!(
      create(:measure, measure_generating_regulation_id: "R3333333")
    )
  end

  let!(:b_measure) do
    set_searchable_jsonb_data!(
      create(:measure, measure_generating_regulation_id: "R3344444")
    )
  end

  let!(:c_measure) do
    set_searchable_jsonb_data!(
      create(:measure,
        measure_generating_regulation_id: "R1715780",
        justification_regulation_id: "R5555555")
    )
  end

  describe "Valid Search" do
    it "filters by regulation with operator" do
      #
      # 'is' filter
      #
      res = search_results(
        enabled: true,
        operator: 'is',
        value: "R3333333"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(a_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'is',
        value: "R5555555"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(c_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'is',
        value: "R1715780"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(c_measure.measure_sid)

      #
      # 'is_not' filter
      #
      res = search_results(
        enabled: true,
        operator: 'is_not',
        value: "R3344444"
      )

      expect(res.count).to be_eql(2)
      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).not_to include(b_measure.measure_sid)

      #
      # 'contains' filter
      #
      res = search_results(
        enabled: true,
        operator: 'contains',
        value: "33"
      )

      expect(res.count).to be_eql(2)
      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).not_to include(c_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'contains',
        value: "R1715780"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(c_measure.measure_sid)

      #
      # 'does_not_contain' filter
      #
      res = search_results(
        enabled: true,
        operator: 'does_not_contain',
        value: "33"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(c_measure.measure_sid)
    end
  end

  private

  def set_searchable_jsonb_data!(m)
    m.set_searchable_data!
    m.save

    m.reload
  end
end
