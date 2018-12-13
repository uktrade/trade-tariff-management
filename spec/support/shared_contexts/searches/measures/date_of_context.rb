require 'rails_helper'

shared_context "measures_search_date_of_context" do
  before do
    set_date(a_measure, field_name, 3.days.ago)
    set_date(b_measure, field_name, 2.days.ago)
    set_date(c_measure, field_name, 1.days.ago)
  end

  it "filters by operator values" do
    #
    # 'is' filter
    #
    res = search_results(
      enabled: true,
      operator: 'is',
      mode: search_mode,
      value: 2.days.ago.strftime('%d/%m/%Y')
    )

    expect(res.count).to be_eql(1)
    expect(res[0].measure_sid).to be_eql(b_measure.measure_sid)

    res = search_results(
      enabled: true,
      operator: 'is',
      mode: search_mode,
      value: 3.days.ago.strftime('%d/%m/%Y')
    )

    expect(res.count).to be_eql(1)
    expect(res[0].measure_sid).to be_eql(a_measure.measure_sid)

    #
    # 'is_not' filter
    #
    res = search_results(
      enabled: true,
      operator: 'is_not',
      mode: search_mode,
      value: 3.days.ago.strftime('%d/%m/%Y')
    )

    expect(res.count).to be_eql(2)
    measure_sids = res.map(&:measure_sid)
    expect(measure_sids).not_to include(a_measure.measure_sid)

    #
    # 'is_after' filter
    #
    res = search_results(
      enabled: true,
      operator: 'is_after',
      mode: search_mode,
      value: 2.days.ago.strftime('%d/%m/%Y')
    )

    expect(res.count).to be_eql(1)
    expect(res[0].measure_sid).to be_eql(c_measure.measure_sid)

    #
    # 'is_before' filter
    #
    res = search_results(
      enabled: true,
      operator: 'is_before',
      mode: search_mode,
      value: 2.days.ago.strftime('%d/%m/%Y')
    )

    expect(res.count).to be_eql(1)
    expect(res[0].measure_sid).to be_eql(a_measure.measure_sid)
  end
end
