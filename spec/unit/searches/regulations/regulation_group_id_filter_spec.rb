require "rails_helper"

describe "Regulations search: Regulation group id filter" do
  include_context "regulations_search_base_context"

  it "should filter" do
    results = search_results(regulation_group_id: group_aaa.regulation_group_id)
    expect(results.count).to be_eql(2)
    expect(results[0].regulation_id).to be_eql(base_i1111111.base_regulation_id)
    expect(results[1].regulation_id).to be_eql(provisional_anti_dumping_i3333333.base_regulation_id)

    results = search_results(regulation_group_id: group_bbb.regulation_group_id)
    expect(results.count).to be_eql(2)
    expect(results[0].regulation_id).to be_eql(base_i2222222.base_regulation_id)
    expect(results[1].regulation_id).to be_eql(definitive_anti_dumping_i4444444.base_regulation_id)
  end
end
