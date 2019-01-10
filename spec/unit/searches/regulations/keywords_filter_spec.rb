require "rails_helper"

describe "Regulations search: Keywords filter" do
  include_context "regulations_search_base_context"

  it "filters" do
    results = search_results(keywords: "Modific")
    expect(results.count).to be_eql(2)
    expect(results[0].regulation_id).to be_eql(modification_r5555555.modification_regulation_id)
    expect(results[1].regulation_id).to be_eql(modification_r6666666.modification_regulation_id)

    results = search_results(keywords: "R9999")
    expect(results.count).to be_eql(1)
    expect(results[0].regulation_id).to be_eql(prorogation_r9999999.prorogation_regulation_id)

    results = search_results(keywords: "Full temporary")
    expect(results.count).to be_eql(1)
    expect(results[0].regulation_id).to be_eql(full_temporary_stop_r9191919.full_temporary_stop_regulation_id)
  end
end
