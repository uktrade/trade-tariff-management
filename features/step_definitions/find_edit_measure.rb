
And(/^I search for the measure by workbasket$/) do
  @find_measure_page = FindMeasurePage.new
  expect(@find_measure_page).to have_measure_sid
  @find_measure_page.find_measure @workbasket
end

And(/^I search for the measure by measure type$/) do
  @find_measure_page = FindMeasurePage.new
  @find_measure_page.find_measure_by_type @measure_type
end

And(/^I search for a measure by measure sid "([^"]*)"$/) do |sid|
  @find_measure_page = FindMeasurePage.new
  @measure_sid = sid
  @find_measure_page.find_measure_by_sid @measure_sid
  expect(@find_measure_page.measure_search_results.size).to eq 1
end

And(/^I search for multiple measures by measure sid "([^"]*)"$/) do |sid|
  @find_measure_page = FindMeasurePage.new
  @measure_sid = sid
  @find_measure_page.find_measure_by_sid @measure_sid
end

And(/^I enter a quota type in the measure type field$/) do
  @quota_type = "122"
  @find_measure_page = FindMeasurePage.new
  @find_measure_page.enter_measure_type @quota_type
end

Then(/^the measure should be locked in the search result$/) do
  expect(@find_measure_page.measure_search_results.size).to eq number_of_codes(@commodity_codes)

  measures_in_workbasket = to_array(@commodity_codes)
  @find_measure_page.measure_search_results.each do |result|
    expect(result).to have_lock
    expect(measures_in_workbasket).to include result.commodity_code.text
  end
end

And(/^each row has a checkbox which is "([^"]*)"$/) do |status|
  expect(@find_measure_page.measure_search_results.size).to eq 1
  case status
    when 'checked'
      @find_measure_page.measure_search_results.each do |result|
        expect(result).not_to have_lock
        expect(result.select).to be_checked
        expect(result.id.text).to eq @measure_sid
      end
    when 'unchecked'
      @find_measure_page.measure_search_results.each do |result|
        expect(result).not_to have_lock
        expect(result.select).not_to be_checked
        expect(result.id.text).to eq @measure_sid
      end
  end
end

And(/^the work_with_selected_measure button is "([^"]*)"$/) do |status|
  case status
    when 'enabled'
      expect(@find_measure_page.work_with_selected_measures).not_to be_disabled
    when 'disabled'
      expect(@find_measure_page.work_with_selected_measures).to be_disabled
  end
end

When(/^I deselect all measures$/) do
  expect(@find_measure_page.select_all).to be_checked
  @find_measure_page.deselect_all_measures
end

Then(/^there is no option displayed for the quota type$/) do
  expect(@find_measure_page.measure_type).not_to have_options
end

And(/^I select measures to work with$/) do
  @workbasket = random_workbasket_name
  @change_start_date = random_past_date
  @regulation = "R1803160"
  @new_regulation = "R1803100"
  @edit_measure_page = EditMeasurePage.new
  number_of_measures = @find_measure_page.measure_search_results.size
  @edit_reason = "Edit measure change reason"

  @find_measure_page.press_work_with_selected_measures
  # expect(@edit_measure_page.selected_measures_alert).to include "You are about to work with #{number_of_measures} selected measures."
  @edit_measure_page.enter_change_start_date @change_start_date
  @edit_measure_page.select_regulation @regulation
  @edit_measure_page.enter_reason_for_change @edit_reason
  @edit_measure_page.enter_workbasket_name @workbasket
  @edit_measure_page.proceed
end


And(/^I select the first available measure to work with$/) do
  @workbasket = random_workbasket_name
  @change_start_date = random_past_date
  @regulation = "R1803160"
  @edit_measure_page = EditMeasurePage.new
  @edit_reason = "Edit measure change reason"

  # select first available measure
  @find_measure_page.deselect_all_measures
  @find_measure_page.measure_search_results.each do |measure|
    if measure.has_no_lock?
      measure.select.click
      break
    end
  end
  @find_measure_page.press_work_with_selected_measures
  @edit_measure_page.enter_change_start_date @change_start_date
  @edit_measure_page.select_regulation @regulation
  @edit_measure_page.enter_reason_for_change @edit_reason
  @edit_measure_page.enter_workbasket_name @workbasket
  @edit_measure_page.proceed
end

And(/^I bulk edit the selected measures with action "([^"]*)"$/) do |bulk_action|
  @test_data = CONFIG['bulk_edit_measure']
  @start_date = random_past_date
  @end_date = random_future_date

  expect(@edit_measure_page.edit_measures_summary.workbasket_name.text).to eq @workbasket
  expect(@edit_measure_page.edit_measures_summary.operation_date.text).to eq format_summary_date @change_start_date
  expect(@edit_measure_page.edit_measures_summary.reason_for_change.text).to eq @edit_reason
  expect(@edit_measure_page.edit_measures_summary.regulation.text).to eq @regulation

  case bulk_action
    when 'Change origin'
      @edit_measure_page.bulk_edit_measures.each do |measure|
        expect(measure.origin.text).not_to eq @test_data['origin']['code']
      end
      @edit_measure_page.select_bulk_action bulk_action
      @edit_measure_page.select_origin @test_data['origin']
    when 'Change commodity codes'
      @edit_measure_page.bulk_edit_measures.each do |measure|
        expect(measure.commodity_code.text).not_to eq @test_data['commodity_codes']
      end
      @edit_measure_page.select_bulk_action bulk_action
      @edit_measure_page.enter_commodity_code @test_data['commodity_codes']
    when 'Change additional code'
      @edit_measure_page.bulk_edit_measures.each do |measure|
        expect(measure.additional_code.text).not_to eq @test_data['additional_codes']
      end
      @edit_measure_page.select_bulk_action bulk_action
      @edit_measure_page.enter_additional_code @test_data['additional_codes']
    when 'Change duties'
      @edit_measure_page.bulk_edit_measures.each do |measure|
        expect(measure.duties.text).not_to eq "#{@test_data['duty_expression']['amount']} %"
      end
      @edit_measure_page.select_bulk_action bulk_action
      @edit_measure_page.add_duty_expression @test_data['duty_expression']
    when 'Change conditions'
      @edit_measure_page.bulk_edit_measures.each do |measure|
        @expected_condition = @test_data['condition'].first
        expect(measure.conditions.text).not_to eq format_conditions @expected_condition
      end
      @edit_measure_page.select_bulk_action bulk_action
      @edit_measure_page.add_conditions @test_data['condition']
    when 'Change footnotes'
      @edit_measure_page.bulk_edit_measures.each do |measure|
        expect(measure.footnotes.text).not_to eq format_footnote @test_data['footnote']
      end
      @edit_measure_page.select_bulk_action bulk_action
      @edit_measure_page.add_footnote @test_data['footnote']
    when 'Change generating regulation'
      @edit_measure_page.bulk_edit_measures.each do |measure|
        expect(measure.regulation.text).not_to eq format_regulation @new_regulation
      end
      @edit_measure_page.select_bulk_action bulk_action
      @edit_measure_page.select_regulation @new_regulation
    when 'Change validity period'
      @edit_measure_page.bulk_edit_measures.each do |measure|
        expect(measure.start_date.text).not_to eq format_item_date @start_date
        expect(measure.end_date.text).not_to eq format_item_date @end_date
      end
      @edit_measure_page.select_bulk_action bulk_action
      @edit_measure_page.enter_start_date @start_date
      @edit_measure_page.enter_end_date @end_date
  end
  @edit_measure_page.updated_selected_measures
end

And(/^the measure is updated with the "([^"]*)" change$/) do |bulk_action|
  case bulk_action
    when 'Change origin'
      @edit_measure_page.bulk_edit_measures.each do |measure|
        expect(measure.origin.text).to eq @test_data['origin']['code']
      end
    when 'Change commodity codes'
      @edit_measure_page.bulk_edit_measures.each do |measure|
        expect(measure.commodity_code.text).to eq @test_data['commodity_codes']
      end
    when 'Change additional code'
      @edit_measure_page.bulk_edit_measures.each do |measure|
        expect(measure.additional_code.text).to eq @test_data['additional_codes']
      end
    when 'Change duties'
      @edit_measure_page.bulk_edit_measures.each do |measure|
        expect(measure.duties.text).to eq "#{@test_data['duty_expression']['amount']} %"
      end
    when 'Change conditions'
      @edit_measure_page.bulk_edit_measures.each do |measure|
        expect(measure.conditions.text).to eq format_conditions @expected_condition
      end
    when 'Change footnotes'
      @edit_measure_page.bulk_edit_measures.each do |measure|
        expect(measure.footnotes.text).to eq format_footnote @test_data['footnote']
      end
    when 'Change generating regulation'
      @edit_measure_page.bulk_edit_measures.each do |measure|
        expect(measure.regulation.text).to eq format_regulation @new_regulation
      end
    when 'Change validity period'
      @edit_measure_page.bulk_edit_measures.each do |measure|
        expect(measure.start_date.text).to eq format_item_date @start_date
        expect(measure.end_date.text).to eq format_item_date @end_date
      end
  end
  @edit_measure_page.save_progress
  expect(@edit_measure_page).to have_no_conformance_errors
  @edit_measure_page.ok_no_conformance_errors
end

And(/^I submit the bulk edit measure for cross-check$/) do
  @edit_measure_page.submit_for_crosscheck
  expect(@edit_measure_page.confirm_submission.message.text).to include "#{@workbasket}"
end

Then(/^the search results are displayed$/) do
  expect(@find_measure_page.measure_search_results.size).to be >= 1
  @number_of_measures_found = @find_measure_page.number_of_search_results
end

Then(/^there is "([^"]*)" measure in the search result$/) do |number|
  expect(@find_measure_page.measure_search_results.size).to eq number.to_i
end

Then(/^the search returns the same number of measures$/) do
  expect(@find_measure_page.number_of_search_results).to eq @number_of_measures_found
end

And(/^I continue with submission for cross-check$/) do
  step 'I click "Continue"'
  @edit_measure_page.submit_for_crosscheck
end

