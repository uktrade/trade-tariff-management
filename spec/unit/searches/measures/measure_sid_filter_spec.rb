require "rails_helper"

describe "Measure search: measure_sid filter" do
  include_context "measures_search_is_or_is_not_context"

  let(:search_key) { "measure_sid" }

  let(:a_measure_sid) { 3632261 }

  let(:a_measure) do
    generate_measure(a_measure_sid)
  end

  let(:b_measure_sid) { 4556446 }

  let(:b_measure) do
    generate_measure(b_measure_sid)
  end

  let(:c_measure_sid) { 6445435 }

  let(:c_measure) do
    generate_measure(c_measure_sid)
  end

  before do
    a_measure
    b_measure
    c_measure
  end

  describe "Valid Search" do
    it "should filter by additional_code_id with operator" do
      #
      # 'is' filter, single value
      #

      res = search_results(
        enabled: true,
        operator: 'is',
        value: b_measure_sid
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(b_measure_sid)

      #
      # 'is' filter, SIDs list comma separated
      #

      res = search_results(
        enabled: true,
        operator: 'is',
        value: "#{a_measure_sid}, #{c_measure_sid}"
      )

      expect(res.count).to be_eql(2)
      expect(res[0].measure_sid).to be_eql(c_measure_sid)
      expect(res[1].measure_sid).to be_eql(a_measure_sid)

      #
      # 'starts_with' filter
      #

      res = search_results(
        enabled: true,
        operator: 'starts_with',
        value: c_measure_sid.to_s[0..3]
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(c_measure_sid)


      #
      # 'contains' filter
      #

      res = search_results(
        enabled: true,
        operator: 'contains',
        value: a_measure_sid.to_s[1..2]
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(a_measure_sid)
    end
  end

  def generate_measure(measure_sid)
    record = build(:measure)
    record.measure_sid = measure_sid
    record.save

    record
  end
end
