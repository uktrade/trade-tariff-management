require "rails_helper"

describe "Measure search: valid_to filter" do
  include_context "measures_search_base_context"
  include_context "measures_date_universal_context"

  let(:search_key) { "valid_to" }
  let(:field_name) { "validity_end_date" }

  describe "Valid Search" do
    it "should filter by operator" do
      res = search_results(
        enabled: true,
        operator: 'is',
        value: 2.days.ago.strftime('%d/%m/%Y')
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(b_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'is_not',
        value: 2.days.ago.strftime('%d/%m/%Y')
      )

      expect(res.count).to be_eql(3)
      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).not_to include(b_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'is_after',
        value: 3.days.ago.strftime('%d/%m/%Y')
      )

      expect(res.count).to be_eql(2)
      expect(res[0].measure_sid).to be_eql(c_measure.measure_sid)
      expect(res[1].measure_sid).to be_eql(b_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'is_before',
        value: 2.days.ago.strftime('%d/%m/%Y')
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(a_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'is_after_or_nil',
        value: 3.days.ago.strftime('%d/%m/%Y')
      )

      expect(res.count).to be_eql(3)
      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).not_to include(a_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'is_before_or_nil',
        value: 2.days.ago.strftime('%d/%m/%Y')
      )

      expect(res.count).to be_eql(2)
      expect(res[0].measure_sid).to be_eql(d_measure.measure_sid)
      expect(res[1].measure_sid).to be_eql(a_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'is_not_specified'
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(d_measure.measure_sid)

      res = search_results(
        enabled: true,
        operator: 'is_not_unspecified'
      )

      expect(res.count).to be_eql(3)
      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).not_to include(d_measure.measure_sid)
    end
  end

  include_context "measures_search_valid_to_from_blank_ops_context"
end
