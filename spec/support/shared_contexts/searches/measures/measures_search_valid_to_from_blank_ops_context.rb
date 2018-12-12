require 'rails_helper'

shared_context "measures_search_valid_to_from_blank_ops_context" do
  describe "Invalid Search" do
    it "should not filter if value option is blank" do
      res = search_results(
        enabled: true,
        operator: 'is'
      )

      expect(res.count).to be_eql(4)
    end

    it "should not filter with blank options provided" do
      res = search_results({})

      expect(res.count).to be_eql(4)
    end
  end
end
