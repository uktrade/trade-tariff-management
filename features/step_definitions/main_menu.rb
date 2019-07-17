
require_relative '../support/helper'
include Helper

Then(/^the main menu links are displayed$/) do
  expect(@tarriff_main_menu).to have_logout_link
  expect(@tarriff_main_menu).to have_create_measures_link
  expect(@tarriff_main_menu).to have_find_edit_measures_link
  expect(@tarriff_main_menu).to have_create_quotas_link
  expect(@tarriff_main_menu).to have_find_edit_quotas_link
  expect(@tarriff_main_menu).to have_find_edit_regulations_link
  expect(@tarriff_main_menu).to have_create_reglutaions_link
  expect(@tarriff_main_menu).to have_find_edit_additional_codes_link
  expect(@tarriff_main_menu).to have_create_additional_codes_link
  expect(@tarriff_main_menu).to have_find_edit_geo_areas_link
  expect(@tarriff_main_menu).to have_create_geo_areas_link
  expect(@tarriff_main_menu).to have_find_edit_certificates_link
  expect(@tarriff_main_menu).to have_create_certificates_link
  expect(@tarriff_main_menu).to have_find_edit_footnotes_link
  expect(@tarriff_main_menu).to have_create_footnotes_link
  expect(@tarriff_main_menu).to have_xml_generation_link
  expect(@tarriff_main_menu).to have_rollbacks_link
end

When(/^I login as a "([^"]*)"$/) do |user|
  step 'I return to the tariff main menu'
  @tarriff_main_menu.logout
  @tarriff_main_menu.load
  @sso_login_page.login_as(user)
end

And(/^I can logout of the application$/) do
  @tarriff_main_menu.logout
  expect(page.current_url).to have_content('auth/developer')
end

Then(/^the workbasket status is "([^"]*)"$/) do |status|
  @basket = find_work_basket
  @basket_id = @basket.id.text
  expect(@basket.status.text).to eq status
end

And(/^the workbasket has next step "([^"]*)"$/) do |next_step|
  case next_step
    when 'Continue'
      expect(@basket).to have_continue
    when 'Delete'
      expect(@basket).to have_delete
    when 'Withdraw/edit'
      expect(@basket).to have_withdraw_edit
    when 'View'
      expect(@basket).to have_view
    when 'Review for cross-check'
      expect(@basket).to have_cross_check
    when 'Review for approval'
      expect(@basket).to have_approve
  end
end

When(/^I click "([^"]*)"$/) do |link|
  @basket = find_work_basket
  case link
    when "Continue"
      @basket.continue.click
    when "Delete"
      @basket.delete.click
    when 'Withdraw/edit'
      @basket.withdraw_edit.click
    when 'View'
      @basket.view.click
    when 'Review for cross-check'
      @basket.cross_check.click
    when 'Review for approval'
      @basket.approve.click
  end
end

Then(/^I can delete the workbasket$/) do
  @tarriff_main_menu.confirmation_modal.confirm_button.click
  expect(@tarriff_main_menu.work_baskets.map {|basket| basket.name.text}).not_to include(@workbasket)
end

And(/^I can view the workbasket$/) do
  @work_basket_page = WorkBasketPage.new
  step 'I click "View"'
  expect(@work_basket_page).to have_work_basket_details
  expect(@work_basket_page.work_basket_details.workbasket_name.text).to eq @workbasket
  expect(@work_basket_page).to have_configuration_summary
  expect(@work_basket_page).to have_measures_to_be_created
end

Then(/^I can withdraw the workbasket$/) do
  step 'I click "Withdraw/edit"'
  @tarriff_main_menu.confirmation_modal.confirm_button.click
end

Then(/^I can withdraw the workbasket for the quota$/) do
  step 'I click "Withdraw/edit"'
  @tarriff_main_menu.confirmation_modal.confirm_button.click
  expect(@create_quota_page.quota_order_number.value).to eq @quota_order_number
end

Then(/^I can crosscheck and accept the workbasket$/) do
  @cross_check_page = CrossCheckPage.new
  expect(@cross_check_page.work_basket_details.work_basket_name.text).to eq @workbasket
  @cross_check_page.accept_cross_check
  expect(@cross_check_page.cross_check_confirmation).to have_header
  expect(@cross_check_page.cross_check_confirmation).to have_message
  expect(@cross_check_page).to have_return_to_main_menu
  expect(@cross_check_page).to have_view_these_measure
end

And(/^I approve the workbasket$/) do
  expect(@cross_check_page.work_basket_details.work_basket_name.text).to eq @workbasket
  @cross_check_page.accept_approval
  expect(@cross_check_page.cross_check_confirmation.header.text).to eq CrossCheckPage::APPROVAL_ACCEPTED_HEADER
  expect(@cross_check_page.cross_check_confirmation.message.text).to include @workbasket
  expect(@cross_check_page).to have_return_to_main_menu
  expect(@cross_check_page).to have_view_these_measure
end

And(/^I do not approve the workbasket$/) do
  expect(@cross_check_page.work_basket_details.work_basket_name.text).to eq @workbasket
  @cross_check_page.reject_approval
  expect(@cross_check_page.cross_check_confirmation.header.text).to eq CrossCheckPage::APPROVAL_REJECTED_HEADER
  expect(@cross_check_page.cross_check_confirmation.message.text).to include CrossCheckPage::APPROVAL_REJECTED_MESSAGE
  expect(@cross_check_page.cross_check_confirmation.message.text).to include @workbasket
  expect(@cross_check_page).to have_return_to_main_menu
end

Then(/^I can crosscheck and reject the workbasket$/) do
  @cross_check_page = CrossCheckPage.new
  expect(@cross_check_page.work_basket_details.work_basket_name.text).to eq @workbasket
  @cross_check_page.reject_cross_check
  expect(@cross_check_page.cross_check_confirmation.header.text).to eq CrossCheckPage::CROSS_CHECK_REJECTED_HEADER
  expect(@cross_check_page.cross_check_confirmation.message.text).to include @workbasket
  expect(@cross_check_page).to have_return_to_main_menu
  expect(@cross_check_page).to have_cross_check_next_workbasket
end

Then(/^the workbasket is no longer displayed$/) do
  expect(@tarriff_main_menu.work_baskets.map {|basket| basket.name.text}).not_to include(@workbasket)
end

When(/^I click on XML generation$/) do
  @tarriff_main_menu.generate_xml
end

And(/^I click the find and edit quota link$/) do
  @tarriff_main_menu.find_edit_quota
end

And(/^I click the find and edit measure link$/) do
  @tarriff_main_menu.find_edit_measure
end

def find_work_basket
  @workbaskets = @tarriff_main_menu.work_baskets.select {|basket| basket.name.text == @workbasket}
  @workbaskets.pop
end

