require "rails_helper"

describe "Regulations search: Role filter" do
  include_context "regulations_search_base_context"

  it "should filter" do
    results = search_results(role: 5)
    expect(results.count).to be_eql(1)
    expect(results[0].regulation_id).to be_eql(prorogation_r9999999.prorogation_regulation_id)

    results = search_results(role: 8)
    expect(results.count).to be_eql(1)
    expect(results[0].regulation_id).to be_eql(full_temporary_stop_r9191919.full_temporary_stop_regulation_id)
  end
end
