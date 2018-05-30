require 'rails_helper'

shared_context "measures_search_is_or_is_not_context" do

  describe "Invalid Search" do
    it "should not filter with 'is' if value blank" do
      res = search_results(
        operator: 'is'
      )

      expect(res.count).to be_eql(3)
    end

    it "should not filter with 'is_not' if value blank" do
      res = search_results(
        operator: 'is_not'
      )

      expect(res.count).to be_eql(3)
    end

    it "should not filter with blank ops provided" do
      res = search_results({})

      expect(res.count).to be_eql(3)
    end
  end

  private

    def search_results(ops)
      ::Measures::Search.new(
        search_key.to_sym => ops
      ).results
       .to_a
    end
end
