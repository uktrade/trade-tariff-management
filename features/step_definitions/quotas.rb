
require_relative '../support/helper'
include Helper

And("I open a new create quota form") do
  @create_quota_page = CreateQuotaPage.new
  @tarriff_main_menu.open_new_quota_form
  expect(@create_quota_page).to have_quota_order_number
end

When("I fill in the quota form for a {string}") do |scenario|

  test_data = CONFIG[scenario]
  @commodity_codes = test_data['commodity_codes']
  @regulation = test_data['regulation']
  @exceptions = test_data['exceptions']
  @additional_codes = test_data['additional_codes']
  @origin = test_data['origin']
  @quota_order_number = random_quota_number
  @quota_type = test_data['quota_type']
  @quota_period = test_data['quota_period']
  @footnote = test_data['footnote']
  @start_date = random_future_date
  @condition = test_data['condition']
  @duty_expression = test_data['duty_expression']
  @section_duration = test_data['section_duration']
  @measurement_unit = test_data['measurement_unit']
  @opening_balance = test_data['opening_balance']
  @maximum_precision = test_data['maximum_precision']

  @create_quota_page.select_regulation @regulation
  @create_quota_page.enter_quota_order_number @quota_order_number
  @create_quota_page.select_maximum_precision @maximum_precision
  @create_quota_page.select_quota_type @quota_type
  @create_quota_page.enter_quota_description "ATT #{@quota_order_number}"
  @create_quota_page.enter_operation_date @start_date
  @create_quota_page.enter_commodity_codes @commodity_codes
  @create_quota_page.enter_exceptions @exceptions unless @exceptions.nil?
  @create_quota_page.enter_additional_codes @additional_codes unless @additional_codes.nil?
  @create_quota_page.select_origin @origin
  @create_quota_page.continue

  @create_quota_page.select_quota_period_type @quota_period
  @create_quota_page.enter_section_start_date @start_date
  @create_quota_page.select_section_duration @section_duration
  @create_quota_page.select_measurement_unit @measurement_unit
  @create_quota_page.enter_opening_balance @opening_balance
  @create_quota_page.add_duty_expression @duty_expression unless @duty_expression.nil?
  @create_quota_page.continue

  @create_quota_page.add_conditions @condition unless @condition.nil?
  @create_quota_page.add_footnote @footnote unless @footnote.nil?
  @create_quota_page.continue
end

And("I can review the quota") do
  expect(@create_quota_page.quota_summary.order_number.text).to eq(@quota_order_number)
  expect(@create_quota_page.quota_summary.maximum_precision.text).to eq(@maximum_precision)
  expect(@create_quota_page.quota_summary.type.text).to include(@quota_type)
  # expect(@create_quota_page.quota_summary.operation_date.text).to include(@start_date)
  expect(@create_quota_page.quota_summary.regulation.text).to eq(format_regulation(@regulation))
  expect(@create_quota_page.quota_summary.origin.text).to include(@origin['name'])
end

And("I can review the quota for commodity codes") do
  expect(to_array @create_quota_page.quota_summary.goods.text).to eq(to_array @commodity_codes)
end

And("I can review the quota for footnotes") do
  expect(@create_quota_page.quota_summary.footnotes.text).to include(format_footnote @footnote)
end

And("I can review the quota for conditions") do
  expect(@create_quota_page.quota_summary.conditions.text).to include(format_conditions @condition)
end

And("I can review the quota for goods exceptions") do
  expect(to_array @create_quota_page.quota_summary.goods_exceptions.text).to eq(to_array @exceptions)
  # expect(@create_quota_page.measures_to_be_created.commodity_codes.map(&:text)).not_to include(to_array @exceptions)
end

And("I can review the quota for additional codes") do
  expect(to_array @create_quota_page.quota_summary.additional_codes.text).to eq(to_array @additional_codes)
end

And("I submit the quota for crosscheck") do
  @create_quota_page.submit_measure_for_cross_check
  binding.pry
end

Then("the quota is submitted") do
  expect(@create_quota_page.confirm_submission).to have_header
  expect(@create_quota_page.confirm_submission.message.text).to include(@quota_order_number)
end
