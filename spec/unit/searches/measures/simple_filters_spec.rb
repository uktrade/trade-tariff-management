require "rails_helper"

describe "Measure search: simple filters" do
  include_context "measures_search_base_context"

  let(:adam) do
    create(:user)
  end

  let(:bredd) do
    create(:user)
  end

  let(:a_measure) do
    create(:measure, added_by_id: adam.id, last_update_by_id: bredd.id, status: 'published')
  end

  let(:b_measure) do
    create(:measure, added_by_id: bredd.id, last_update_by_id: adam.id, status: 'published')
  end

  let(:c_measure) do
    create(:measure, added_by_id: adam.id, last_update_by_id: adam.id, status: 'published')
  end

  before do
    adam
    bredd

    a_measure
    b_measure
    c_measure
  end

  describe "published measures" do
    let(:search_key) { nil }

    it "shows all published measures" do
      res = search_results(enabled: true)
      expect(res.count).to eq 3
    end

    it "does not show measures that are not published" do
      c_measure.status = 'awaiting_cross_check'
      c_measure.save

      res = search_results(enabled: true)
      statuses = res.map(&:status)

      expect(res.count).to eq 2
      expect(statuses.include?('awaiting_cross_check')).to eq false
    end
  end

  describe "Author filter" do
    let(:search_key) { "author" }

    it "filters" do
      res = search_results(
        enabled: true,
        value: adam.id
      )

      expect(res.count).to be_eql(2)
      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).not_to include(b_measure.measure_sid)

      res = search_results(
        enabled: true,
        value: bredd.id
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(b_measure.measure_sid)
    end

    include_context "measures_search_simple_filters_blank_ops_context"
  end

  describe "Last updated by filter" do
    let(:search_key) { "last_updated_by" }

    it "filters" do
      res = search_results(
        enabled: true,
        value: adam.id
      )

      expect(res.count).to be_eql(2)
      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).not_to include(a_measure.measure_sid)

      res = search_results(
        enabled: true,
        value: bredd.id
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(a_measure.measure_sid)
    end

    include_context "measures_search_simple_filters_blank_ops_context"
  end
end
