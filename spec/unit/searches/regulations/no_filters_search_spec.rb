require "rails_helper"

describe "Regulations search: No filters" do
  include_context "regulations_search_base_context"

  it "filters" do
    results = search_results({})
    expect(results.count).to be_eql(10)
  end
end
