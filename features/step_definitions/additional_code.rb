When("I click on the link Create new additional codes") do
  @tarriff_main_menu.open_new_additional_code_form
end

Then("Create new additional codes form is displayed") do
   @additional_code_page = AdditionalCodesPage.new
  expect(@additional_code_page).to have_workbasket
  expect(@additional_code_page).to have_additional_code_type


end

When("I enter the workbasket name") do
  @additional_code_page = AdditionalCodesPage.new
  @workbasket = "vara"
  @additional_code_page.enter_workbasket_name @workbasket
end

When("I enter the start date") do
  @additional_code_page.enter_start_date format_date random_future_date
end

When("I click on save button") do
  @additional_code_page.click_save
  end

And(/^I enter additional code type$/) do

  @additional_code_page.additional_code_type.hover
  @additional_code_page.additional_code_type.click
  @additional_code_page.code_values[1].click
end

And(/^I enter additional code$/) do
  @additional_code_page.additional_code.send_keys("Sam")
end

And(/^I enter desciption$/) do
  @additional_code_page.additional_code_description.send_keys("Sample Description")
end

And(/^I click on the submit for cross\-check button$/) do
  @additional_code_page.submit_for_crosscheck_button.click
end