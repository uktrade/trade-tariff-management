require 'rails_helper'

shared_context "measures_search_simple_filters_blank_ops_context" do
  it "should not filter if value is blank" do
    res = search_results(enabled: true, value: "")
    expect(res.count).to be_eql(3)

    res = search_results({})
    expect(res.count).to be_eql(3)
  end
end
