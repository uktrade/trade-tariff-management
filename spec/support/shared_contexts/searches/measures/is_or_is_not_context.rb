require 'rails_helper'

shared_context "measures_search_is_or_is_not_context" do
  include_context "measures_search_base_context"

  let(:is_not_context_number_of_measures) { 3 }

  describe "Invalid Search" do
    it "should not filter with 'is' if value blank" do
      res = search_results(
        enabled: true,
        operator: 'is'
      )

      expect(res.count).to be_eql(is_not_context_number_of_measures)
    end

    it "should not filter with 'is_not' if value blank" do
      res = search_results(
        enabled: true,
        operator: 'is_not'
      )

      expect(res.count).to be_eql(is_not_context_number_of_measures)
    end

    it "should not filter with blank ops provided" do
      res = search_results({})

      expect(res.count).to be_eql(is_not_context_number_of_measures)
    end
  end
end
