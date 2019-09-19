
When(/^I open a new additional code form$/) do
  @create_additional_code = CreateAdditionalCodePage.new
  @tarriff_main_menu.open_new_additional_code_form
end

And(/^I fill the additional codes form for "([^"]*)"$/) do |scenario|

  test_data = CONFIG[scenario]
  @workbasket = random_workbasket_name
  @additional_codes = test_data['additional_codes']
  @start_date = random_future_date

  @create_additional_code.enter_workbasket_name @workbasket
  @create_additional_code.input_date_gds('#start_date', @start_date)
  @create_additional_code.add_additional_code @additional_codes
end

Then(/^I can submit the additional code for cross-check$/) do
  step 'I submit the additional codes for crosscheck'
  step 'the additional codes are submitted'
end

And(/^I submit the additional codes for crosscheck$/) do
  @create_additional_code.submit_for_cross_check
end

Then(/^the additional codes are submitted$/) do
  expect(@create_additional_code.confirm_submission).to have_header
  expect(@create_additional_code.confirm_submission.message.text).to eq "#{@additional_codes.size} new additional codes have been submitted for cross-check."
end
