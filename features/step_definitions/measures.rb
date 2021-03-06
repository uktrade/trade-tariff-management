
require_relative '../support/helper'
include Helper

Given(/^I am on the tariff main menu$/) do
  @sso_login_page = SSOLoginPage.new
  @tarriff_main_menu = TariffMainMenuPage.new

  @tarriff_main_menu.load
  @sso_login_page.login
  expect(@tarriff_main_menu).to have_create_measures_link
end

And(/^I create a new measure$/) do
  @create_measure_page = CreateMeasurePage.new
  @tarriff_main_menu.create_measures_link.click
  expect(@create_measure_page).to have_measure_validity_start_date
  @create_measure_page.workbasket_name.set random_workbasket_name
  @create_measure_page.continue_button.click
end

And(/^I open a new create measure form$/) do
  @create_measure_page = CreateMeasurePage.new
  @tarriff_main_menu.open_new_measure_form
  expect(@create_measure_page).to have_measure_validity_start_date
end

And(/^I press Continue$/) do
  @create_measure_page.continue_button.click
end

And(/^I submit an empty form$/) do
  step 'I press Continue'
  step 'I press Continue'
end

And(/^I save progress$/) do
  step 'I press Continue'
  @create_measure_page.save_progress
end

Then(/^errors indicating the mandatory fields are displayed$/) do
  expect(@create_measure_page).to have_error_summary
  expect(@create_measure_page.error_summary.errors.size).to eq 5
  expect(@create_measure_page.error_summary.errors.map(&:text)).to eq([CreateMeasurePage::NO_START_DATE_MESSAGE,
                                                                       CreateMeasurePage::NO_WORKBASKET_NAME_MESSAGE,
                                                                       CreateMeasurePage::NO_REGULATION_MESSAGE,
                                                                       CreateMeasurePage::NO_MEASURE_TYPE_MESSAGE,
                                                                       CreateMeasurePage::NO_ORIGIN_MESSAGE])
end

When(/^I enter all mandatory fields except "([^"]*)"$/) do |string|

  test_data = CONFIG['single_commodity_code']
  regulation = test_data['regulation']
  measure_type = test_data['measure_type']
  commodity_code = test_data['commodity_codes']
  origin = test_data['origin']
  start_date = Date.today

  case string
    when 'commodity_codes'
      @create_measure_page.enter_workbasket_name random_workbasket_name
      @create_measure_page.enter_measure_start_date start_date
      @create_measure_page.select_regulation regulation
      @create_measure_page.select_measure_type measure_type
      @create_measure_page.select_origin origin
      enter_optional_fields
    when 'start_date'
      @create_measure_page.enter_workbasket_name random_workbasket_name
      @create_measure_page.enter_commodity_codes commodity_code
      @create_measure_page.select_regulation regulation
      @create_measure_page.select_measure_type measure_type
      @create_measure_page.select_origin origin
      enter_optional_fields
    when 'workbasket_name'
      @create_measure_page.enter_measure_start_date start_date
      @create_measure_page.enter_commodity_codes commodity_code
      @create_measure_page.select_regulation regulation
      @create_measure_page.select_measure_type measure_type
      @create_measure_page.select_origin origin
      enter_optional_fields
    when 'origin'
      @create_measure_page.enter_workbasket_name random_workbasket_name
      @create_measure_page.enter_measure_start_date start_date
      @create_measure_page.select_regulation regulation
      @create_measure_page.enter_commodity_codes commodity_code
      @create_measure_page.select_measure_type measure_type
      enter_optional_fields
    when 'regulation'
      @create_measure_page.enter_workbasket_name random_workbasket_name
      @create_measure_page.enter_measure_start_date start_date
      @create_measure_page.enter_commodity_codes commodity_code
      @create_measure_page.select_measure_type measure_type
      @create_measure_page.select_origin origin
      enter_optional_fields
    when 'measure_type'
      @create_measure_page.enter_workbasket_name random_workbasket_name
      @create_measure_page.enter_measure_start_date start_date
      @create_measure_page.select_regulation regulation
      @create_measure_page.enter_commodity_codes commodity_code
      @create_measure_page.select_origin origin
      enter_optional_fields
  end
end

def enter_optional_fields
  test_data = CONFIG['single_commodity_code']
  @duty_expression = test_data['duty_expression']
  @create_measure_page.continue
  @create_measure_page.add_duty_expression @duty_expression
  @create_measure_page.continue
end

Then(/^an "([^"]*)" error message is displayed$/) do |string|
  expect(@create_measure_page.error_summary.errors.size).to eq 1
  error_message = @create_measure_page.error_summary.errors.map(&:text).pop

  case string
    when 'commodity_codes'
      expect(error_message).to match(/#{CreateMeasurePage::ME9_ERROR}/)
    when 'start_date'
      expect(error_message).to eq(CreateMeasurePage::NO_START_DATE_MESSAGE)
    when 'workbasket_name'
      expect(error_message).to eq(CreateMeasurePage::NO_WORKBASKET_NAME_MESSAGE)
    when 'origin'
      expect(error_message).to eq(CreateMeasurePage::NO_ORIGIN_MESSAGE)
    when 'regulation'
      expect(error_message).to match(/#{CreateMeasurePage::NO_REGULATION_MESSAGE}/)
    when 'ME25'
      expect(error_message).to match(/#{CreateMeasurePage::ME25_ERROR}/)
    when 'duty_expression'
      expect(error_message).to match()
    when 'measure_type'
      expect(error_message).to match(/#{CreateMeasurePage::NO_MEASURE_TYPE_MESSAGE}/)
    when 'ME12'
      expect(error_message).to match(/#{CreateMeasurePage::ME12_ERROR}/)
    when 'ME1'
      expect(error_message).to match(/#{CreateMeasurePage::ME1_ERROR}/)
    when 'ME32'
      expect(error_message).to match(/#{CreateMeasurePage::ME32_ERROR}/)
  end
end

And(/^I enter an end date which is earlier than the start date$/) do
  test_data = CONFIG['single_commodity_code']
  regulation = test_data['regulation']
  measure_type = test_data['measure_type']
  commodity_code = test_data['commodity_codes']
  start_date = Date.today
  end_date = 3.days.ago
  @workbasket = random_workbasket_name

  @create_measure_page.enter_measure_start_date start_date
  @create_measure_page.enter_measure_end_date end_date
  common_steps(regulation, measure_type, commodity_code)
  enter_optional_fields
end

And(/^I do not enter a duty expression when the selected measure type requires one$/) do
  test_data = CONFIG['single_commodity_code']
  regulation = test_data['regulation']
  measure_type = test_data['measure_type']
  commodity_code = test_data['commodity_codes']
  start_date = Date.today

  @create_measure_page.enter_measure_start_date start_date
  common_steps(regulation, measure_type, commodity_code)
  @create_measure_page.continue
  @create_measure_page.continue
end

When(/^I fill the required fields and enter a "([^"]*)" date$/) do |date|
  regulation = 'R18'
  measure_type = 'Customs Union Duty'
  commodity_code = '1006400010'
  start_date = Date.today
  @workbasket = random_workbasket_name

  case date
    when 'past'
      @create_measure_page.enter_measure_start_date random_past_date
    when 'present'
      @create_measure_page.enter_measure_start_date start_date
    when 'future'
      @create_measure_page.enter_measure_start_date random_future_date
  end
  common_steps(regulation, measure_type, commodity_code)
  enter_optional_fields
end

def common_steps(regulation, measure_type, commodity_code)
  @create_measure_page.select_regulation regulation
  @create_measure_page.select_measure_type measure_type
  @create_measure_page.enter_workbasket_name @workbasket
  @create_measure_page.enter_commodity_codes commodity_code
  @create_measure_page.select_erga_omnes
end

Then(/^the measure can be submitted for cross check$/) do
  expect(@create_measure_page).to have_measure_summary
  expect(@create_measure_page).to have_submit_for_crosscheck_button
end

And(/^I can review the measure$/) do
  expect(@create_measure_page.measure_summary.workbasket_name.text).to eq(@workbasket)
  expect(@create_measure_page.measure_summary.regulation.text).to eq(format_regulation(@regulation))
  expect(@create_measure_page.measure_summary.start_date.text).to eq(format_summary_date(@start_date))
  expect(@create_measure_page.measure_summary.type.text).to include(@measure_type)
  expect(@create_measure_page.measure_summary.origin.text).to include(@origin['name'])
  step 'the measure can be submitted for cross check'
end

And(/^the summary lists the measures to be created$/) do
  expect(@create_measure_page.measures_to_be_created.commodity_codes.map(&:text)).to eq(to_array(@commodity_codes))
end

And(/^the summary lists the additional codes to be created$/) do
  expect(@create_measure_page.measures_to_be_created.additional_codes.map(&:text)).to eq(to_array(@additional_codes))
end

And(/^the measure to be created has a footnote$/) do
  step 'the summary lists the measures to be created'
  expect(@create_measure_page.measures_to_be_created.footnotes.map(&:text).pop).to eq(format_footnote @footnote)
end

And(/^the measure to be created has a condition$/) do
  step 'the summary lists the measures to be created'
  expected_condition = @condition.first
  condition_match = "#{expected_condition['type']}. .#{expected_condition['certificate']} #{expected_condition['action']}"
  expect(@create_measure_page.measures_to_be_created.conditions.map(&:text).pop).to match(/#{condition_match}/)
end

And(/^I can review the measure for goods exceptions$/) do
  expect(to_array @create_measure_page.measure_summary.goods_exceptions.text).to eq(to_array @exceptions)
  expect(@create_measure_page.measures_to_be_created.commodity_codes.map(&:text)).not_to include(to_array @exceptions)
end

And(/^I can review the measure for additional codes$/) do
  expect(to_array @create_measure_page.measure_summary.additional_codes.text).to eq(to_array @additional_codes)
end

And(/^I can review the measure for commodity codes$/) do
  expect(to_array @create_measure_page.measure_summary.goods.text).to eq(to_array @commodity_codes)
end

And(/^I can review the measure for meursing codes$/) do
  expect(to_array @create_measure_page.measure_summary.additional_codes.text).to eq(to_array @additional_codes)
  expect(@create_measure_page.measures_to_be_created.additional_codes.map(&:text)).to eq(to_array @additional_codes)
end

When(/^I fill in the form for a "([^"]*)"$/) do |scenario|
  test_data = CONFIG[scenario]
  @workbasket = random_workbasket_name
  @commodity_codes = test_data['commodity_codes']
  @regulation = test_data['regulation']
  @measure_type = test_data['measure_type']
  @exceptions = test_data['exceptions']
  @additional_codes = test_data['additional_codes']
  @origin = test_data['origin']
  @footnote = test_data['footnote']
  @start_date = random_future_date
  @condition = test_data['condition']
  @duty_expression = test_data['duty_expression']

  @create_measure_page.enter_measure_start_date @start_date
  @create_measure_page.enter_workbasket_name @workbasket
  @create_measure_page.enter_commodity_codes @commodity_codes unless @commodity_codes.nil?
  @create_measure_page.select_regulation @regulation
  @create_measure_page.select_measure_type @measure_type

  @create_measure_page.enter_exceptions @exceptions unless @exceptions.nil?
  @create_measure_page.enter_additional_codes @additional_codes unless @additional_codes.nil?
  @create_measure_page.select_origin @origin
  @create_measure_page.continue
  @create_measure_page.add_duty_expression @duty_expression unless @duty_expression.nil?
  @create_measure_page.add_conditions @condition unless @condition.nil?
  @create_measure_page.add_footnote @footnote unless @footnote.nil?
  @create_measure_page.continue
end

And(/^I submit the measure for crosscheck$/) do
  @create_measure_page.submit_measure_for_cross_check
end

Then(/^the measure is submitted$/) do
  expect(@create_measure_page.confirm_submission).to have_header
  expect(@create_measure_page.confirm_submission.message.text).to include(@workbasket)
end

And (/^I can submit the measure for cross check$/) do
  step 'I submit the measure for crosscheck'
  step 'the measure is submitted'
end

When(/^I go back to the tariff main menu$/) do
  @create_measure_page.return_to_main_menu
end

When(/^I return to the tariff main menu$/) do
  @tarriff_main_menu.load
end

And(/^I check the description of a commodity code$/) do
  test_data = CONFIG['single_additional_code']
  @commodity_codes = test_data['commodity_codes']
  @additional_codes = test_data['additional_codes']

  @create_measure_page.view_commodity_code_description @commodity_codes
end

Then(/^the commodity code description is displayed$/) do
  expect(@create_measure_page).to have_check_commodity_code_description
end

When(/^I check the description of an additional code$/) do
  @create_measure_page.view_additional_code_description @additional_codes
end

Then(/^the additional code description is displayed$/) do
  expect(@create_measure_page).to have_check_additional_code_description
  expect(@create_measure_page.check_additional_code_description.text).to include @additional_codes
end

