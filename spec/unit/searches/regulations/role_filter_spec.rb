require "rails_helper"

describe "Regulations search: Role filter" do

  include_context "regulations_search_base_context"

  it "should filter" do
    results = search_results(role: 1)
    expect(results.count).to be_eql(2)
    expect(results[0].regulation_id).to be_eql(base_i1111111.base_regulation_id)
    expect(results[1].regulation_id).to be_eql(base_i2222222.base_regulation_id)

    results = search_results(role: 2)
    expect(results.count).to be_eql(1)
    expect(results[0].regulation_id).to be_eql(provisional_anti_dumping_i3333333.base_regulation_id)

    results = search_results(role: 3)
    expect(results.count).to be_eql(1)
    expect(results[0].regulation_id).to be_eql(definitive_anti_dumping_i4444444.base_regulation_id)

    results = search_results(role: 4)
    expect(results.count).to be_eql(2)
    expect(results[0].regulation_id).to be_eql(modification_r5555555.modification_regulation_id)
    expect(results[1].regulation_id).to be_eql(modification_r6666666.modification_regulation_id)

    results = search_results(role: 5)
    expect(results.count).to be_eql(1)
    expect(results[0].regulation_id).to be_eql(prorogation_r9999999.prorogation_regulation_id)

    results = search_results(role: 6)
    expect(results.count).to be_eql(1)
    expect(results[0].regulation_id).to be_eql(complete_abrogation_r7777777.complete_abrogation_regulation_id)

    results = search_results(role: 7)
    expect(results.count).to be_eql(1)
    expect(results[0].regulation_id).to be_eql(explicit_abrogation_r8888888.explicit_abrogation_regulation_id)

    results = search_results(role: 8)
    expect(results.count).to be_eql(1)
    expect(results[0].regulation_id).to be_eql(full_temporary_stop_r9191919.full_temporary_stop_regulation_id)
  end
end
