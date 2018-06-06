require "rails_helper"

describe "Measure search: additional code filter" do

  include_context "measures_search_is_or_is_not_context"

  let(:search_key) { "additional_code" }

  let(:a_measure) do
    create(:measure, additional_code_type_id: "C", additional_code_id: "333")
  end

  let(:b_measure) do
    create(:measure, additional_code_type_id: "B", additional_code_id: "334")
  end

  let(:c_measure) do
    create(:measure, additional_code_id: "555")
  end

  before do
    a_measure
    b_measure
    c_measure
  end

  describe "Valid Search" do
    it "should filter by additional_code_id with operator" do
      #
      # 'is' filter
      #
      res = search_results(
        enabled: true,
        operator: 'is',
        value: "333"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(a_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'is',
        value: "c333"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(a_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'is',
        value: "555"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(c_measure.measure_sid)

      #
      # 'is_not' filter
      #
      res = search_results(
        enabled: true,
        operator: 'is_not',
        value: "334"
      )

      expect(res.count).to be_eql(2)
      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).not_to include(b_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'is_not',
        value: "B334"
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
        value: "33"
      )

      expect(res.count).to be_eql(2)
      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).not_to include(c_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'starts_with',
        value: "c"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(a_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'starts_with',
        value: "b3"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(b_measure.measure_sid)
    end
  end
end
