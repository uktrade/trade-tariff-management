require 'rails_helper'

shared_context "measures_date_universal_context" do
  let(:a_measure) do
    create(:measure, field_name.to_sym => 3.days.ago)
  end

  let(:b_measure) do
    create(:measure, field_name.to_sym => 2.days.ago)
  end

  let(:c_measure) do
    create(:measure, field_name.to_sym => 1.days.ago)
  end

  let(:d_measure) do
    create(:measure, field_name.to_sym => nil)
  end

  before do
    a_measure
    b_measure
    c_measure
    d_measure
  end

  describe "Valid Search" do
    it "should filter by operator" do
      res = search_results(
        operator: 'is',
        value: 2.days.ago.strftime('%d/%m/%Y')
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(b_measure.measure_sid)

      res = search_results(
        operator: 'is_not',
        value: 2.days.ago.strftime('%d/%m/%Y')
      )

      expect(res.count).to be_eql(2)
      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).not_to include(b_measure.measure_sid)

      res = search_results(
        operator: 'is_after',
        value: 3.days.ago.strftime('%d/%m/%Y')
      )

      expect(res.count).to be_eql(2)
      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).not_to include(a_measure.measure_sid)

      res = search_results(
        operator: 'is_before',
        value: 2.days.ago.strftime('%d/%m/%Y')
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(a_measure.measure_sid)

      res = search_results(
        operator: 'is_not_specified'
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(d_measure.measure_sid)

      res = search_results(
        operator: 'is_not_unspecified'
      )

      expect(res.count).to be_eql(3)
      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).not_to include(d_measure.measure_sid)
    end
  end
end
