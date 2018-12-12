require "rails_helper"

describe "Regulations search: Start and end date filter" do
  include_context "regulations_search_base_context"

  it "should filter" do
    results = search_results(
      start_date: date_to_format(1.year.ago),
      end_date: date_to_format(5.days.from_now)
    )

    expect(results.count).to be_eql(2)
    expect(results[0].regulation_id).to be_eql(modification_r5555555.modification_regulation_id)
    expect(results[1].regulation_id).to be_eql(modification_r6666666.modification_regulation_id)
  end
end
