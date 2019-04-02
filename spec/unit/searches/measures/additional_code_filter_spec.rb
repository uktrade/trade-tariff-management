require "rails_helper"

describe "Measure search: additional code filter" do
  include_context "measures_search_is_or_is_not_context"

  let(:is_not_context_number_of_measures) { 4 }

  let(:search_key) { "additional_code" }

  let!(:a_measure) do
    set_searchable_data!(
      create(:measure, additional_code_type_id: "C", additional_code_id: "333")
    )
  end

  let!(:b_measure) do
    set_searchable_data!(
      create(:measure, additional_code_type_id: "B", additional_code_id: "334")
    )
  end

  let!(:c_measure) do
    set_searchable_data!(
      create(:measure, additional_code_id: "555")
    )
  end

  let!(:d_measure) do
    set_searchable_data!(
      create(:measure)
    )
  end

  describe "Valid Search" do
    it "filters by additional_code_id with operator" do
      #
      # 'is' filter
      #

      res = search_results(
        enabled: true,
        operator: 'is',
        value: "c333"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(a_measure.measure_sid)

      #
      # 'is_not' filter
      #

      res = search_results(
        enabled: true,
        operator: 'is_not',
        value: "B334"
      )

      expect(res.count).to be_eql(3)
      measure_sids = res.map(&:measure_sid)
      expect(measure_sids).not_to include(b_measure.measure_sid)

      #
      # 'starts_with' filter
      #

      res = search_results(
        enabled: true,
        operator: 'starts_with',
        value: "b3"
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(b_measure.measure_sid)


      #
      # 'is_not_unspecified' filter
      #

      res = search_results(
        enabled: true,
        operator: 'is_not_specified'
      )

      expect(res.count).to be_eql(1)
      expect(res[0].measure_sid).to be_eql(d_measure.measure_sid)

      #
      # 'is_not_unspecified' filter
      #

      res = search_results(
        enabled: true,
        operator: 'is_not_unspecified'
      )

      expect(res.count).to be_eql(3)
    end
  end

  def set_searchable_data!(measure)
    measure.set_searchable_data!
    measure.save

    measure.reload
  end
end
