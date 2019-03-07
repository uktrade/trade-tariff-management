Given("I am on the tariff main menu") do

  @sso_login_page = SSOLoginPage.new
  @sso_login_page.load
  @sso_login_page.login

  @tarriff_main_menu = TariffMainMenuPage.new
  @tarriff_main_menu.load
  expect(@tarriff_main_menu).to have_create_measures_link
end

And("I create a new measure") do
  @create_measure_page = CreateMeasurePage.new
  @tarriff_main_menu.create_measures_link.click
  expect(@create_measure_page).to have_measure_validity_start_date
  @create_measure_page.workbasket_name.set random_workbasket_name
  @create_measure_page.continue_button.click
end

And("I open a new create measure form") do
  @create_measure_page = CreateMeasurePage.new
  @tarriff_main_menu.create_measures_link.click
  expect(@create_measure_page).to have_measure_validity_start_date
end

And("I press Continue") do
  @create_measure_page.continue_button.click
end

And("I submit an empty form") do
  step 'I press Continue'
  step 'I press Continue'
end

And("I save progress") do
  step 'I press Continue'
  @create_measure_page.save_progress
end

Then("errors indicating the mandatory fields are displayed") do
  expect(@create_measure_page).to have_error_summary
  expect(@create_measure_page.error_summary.errors.size).to eq 3
  expect(@create_measure_page.error_summary.errors.map(&:text)).to eq([CreateMeasurePage::NO_START_DATE_MESSAGE, CreateMeasurePage::NO_WORKBASKET_NAME_MESSAGE, CreateMeasurePage::NO_COMMODITY_CODE_MESSAGE])
end

When("I enter all mandatory fields except {string}") do |string|

  regulation = 'R1803160'
  measure_type = 'Third country duty'
  commodity_code = '1004100000'
  start_date = Date.today

  case string
    when 'commodity_codes'
      @create_measure_page.enter_workbasket_name random_workbasket_name
      @create_measure_page.enter_measure_start_date start_date
      @create_measure_page.select_regulation regulation
      @create_measure_page.select_measure_type measure_type
      @create_measure_page.select_erga_omnes
      enter_optional_fields
    when 'start_date'
      @create_measure_page.enter_workbasket_name random_workbasket_name
      @create_measure_page.enter_commodity_codes commodity_code
      @create_measure_page.select_regulation regulation
      @create_measure_page.select_measure_type measure_type
      @create_measure_page.select_erga_omnes
      enter_optional_fields
    when 'workbasket_name'
      @create_measure_page.enter_measure_start_date start_date
      @create_measure_page.enter_commodity_codes commodity_code
      @create_measure_page.select_regulation regulation
      @create_measure_page.select_measure_type measure_type
      @create_measure_page.select_erga_omnes
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
      @create_measure_page.select_erga_omnes
      enter_optional_fields
    when 'measure_type'
      @create_measure_page.enter_workbasket_name random_workbasket_name
      @create_measure_page.enter_measure_start_date start_date
      @create_measure_page.select_regulation regulation
      @create_measure_page.enter_commodity_codes commodity_code
      @create_measure_page.select_erga_omnes
      enter_optional_fields
  end
end

def enter_optional_fields

  measure_type_series = 'Applicable duty'
  duty_amount = 15

  @create_measure_page.select_measure_type_series measure_type_series
  @create_measure_page.continue
  @create_measure_page.add_duty_expression duty_amount
  @create_measure_page.continue
end

Then("an {string} error message is displayed") do |string|
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
      expect(error_message).to eq(CreateMeasurePage::ME4_ERROR)
    when 'regulation'
      expect(error_message).to match(/#{CreateMeasurePage::ME86_ERROR}/)
    when 'end_date'
      expect(error_message).to match(/#{CreateMeasurePage::ME25_ERROR}/)
    when 'duty_expression'
      expect(error_message).to match()
    when 'measure_type'
      expect(error_message).to match(/#{CreateMeasurePage::ME2_ERROR}/)
  end
end

And("I enter an end date which is earlier than the start date") do
  regulation = 'R1803160'
  measure_type_series = 'Applicable duty'
  measure_type = 'Third country duty'
  commodity_code = '1004100000'
  start_date = Date.today
  end_date = 3.days.ago

  @create_measure_page.enter_measure_start_date start_date
  @create_measure_page.enter_measure_end_date end_date
  @create_measure_page.select_regulation regulation
  @create_measure_page.select_measure_type_series measure_type_series
  @create_measure_page.select_measure_type measure_type
  @create_measure_page.enter_workbasket_name random_workbasket_name
  @create_measure_page.enter_commodity_codes commodity_code
  @create_measure_page.select_erga_omnes
  enter_optional_fields
end

And("I do not enter a duty expression when the selected measure type requires one") do
  regulation = 'R1803160'
  measure_type_series = 'Applicable duty'
  measure_type = 'Third country duty'
  commodity_code = '1004100000'
  start_date = Date.today

  @create_measure_page.enter_measure_start_date start_date
  @create_measure_page.select_regulation regulation
  @create_measure_page.select_measure_type_series measure_type_series
  @create_measure_page.select_measure_type measure_type
  @create_measure_page.enter_workbasket_name random_workbasket_name
  @create_measure_page.enter_commodity_codes commodity_code
  @create_measure_page.select_erga_omnes
  @create_measure_page.continue
  @create_measure_page.continue
end

When("I fill the required fields and enter a {string} date") do |string|
  regulation = 'R18'
  measure_type_series = 'Applicable duty'
  measure_type = 'Customs Union Duty'
  commodity_code = '1006400010'
  start_date = Date.today
  duty_amount = 15

  case string
    when 'past'
      @create_measure_page.enter_measure_start_date random_past_date
    when 'present'
      @create_measure_page.enter_measure_start_date start_date
    when 'future'
      @create_measure_page.enter_measure_start_date random_future_date
  end
  @create_measure_page.select_regulation regulation
  @create_measure_page.enter_workbasket_name random_workbasket_name
  @create_measure_page.enter_commodity_codes commodity_code
  @create_measure_page.select_erga_omnes
  @create_measure_page.select_measure_type_series measure_type_series
  @create_measure_page.select_measure_type measure_type
  @create_measure_page.continue
  @create_measure_page.add_duty_expression duty_amount
  @create_measure_page.continue
end

Then("the measure can be submitted for cross check") do
  expect(@create_measure_page).to have_measure_summary
  expect(@create_measure_page).to have_submit_for_crosscheck_button
end

def random_future_date
  number = rand(1..365)
  number.days.from_now
end

def random_past_date
  number = rand(1..365)
  number.days.ago
end

def random_workbasket_name
  number = enter_random_number(6)
  "ATT #{number}"
end

def enter_random_number(number)
  number.times.map{rand(9)}.join
end