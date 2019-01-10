require "rails_helper"

describe "Regulations search: Start date filter" do
  include_context "regulations_search_base_context"

  it "filters" do
    results = search_results(start_date: date_to_format(11.days.ago))
    expect(results.count).to be_eql(2)
    expect(results[0].regulation_id).to be_eql(prorogation_r9999999.prorogation_regulation_id)
    expect(results[1].regulation_id).to be_eql(complete_abrogation_r7777777.complete_abrogation_regulation_id)

    results = search_results(start_date: date_to_format(9.days.ago))
    expect(results.count).to be_eql(1)
    expect(results[0].regulation_id).to be_eql(complete_abrogation_r7777777.complete_abrogation_regulation_id)
  end
end
