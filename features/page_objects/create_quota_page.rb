require_relative 'create_quota_page_elements'
require_relative '../support/helper'

class CreateQuotaPage < CreateQuotaPageElements

  include CapybaraFormHelper

  set_url ENV['QUOTA']

  QUOTA_ERROR = "Need to specify at least of one valid quota period. Period type, Start date, Length of period, Balance and either Measurement or Monetary Unit are required!"

  def select_regulation(reg)
    regulation_dropdown.click
    regulation_dropdown.set reg
    regulations_options.first.click
  end

  def enter_quota_order_number(quota_number)
    quota_order_number.set quota_number
  end

  def select_maximum_precision(precision)
    within("#maximum_precision") do
      select_dropdown(precision)
    end
  end

  def select_quota_type(quota_type)
    within("#record_type_dropdown") do
      select_dropdown_value(quota_type)
    end
  end

  def enter_quota_description(description)
    quota_description.set description
  end

  def enter_operation_date(date)
    operation_date.set format_date(date)
    find("body").click
    end

  def enter_section_start_date(date)
    quota_section.start_date.set format_date(date)
    find("body").click
  end

  def check_licensed_quota
    licenced_quota_check_box.click
  end

  def select_quota_licence(licence)
    within(".workbasket_forms_create_quota_form_quota_licence") do
      select_dropdown_value(licence['type'])
    end
  end

  def enter_commodity_codes(codes)
    commodity_code.set codes
  end

  def enter_exceptions(exception)
    exceptions.set exception
  end

  def enter_additional_codes(codes)
    additional_codes.set codes
  end

  def enter_reduction_indicator(indicator)
    reduction_indicator.set indicator
  end

  def select_origin(origin)
    case origin['type']
      when 'erga_omnes'
        erga_omnes_radio_button.click
      when 'group'
        country_groups_radio_button.click
        select_origin_group origin['name']
      when 'country'
        country_region_radio_button.click
        select_origin_country origin['name']
    end
  end

  def select_origin_group(group)
    within("div.origins-region div.measure-origin:nth-child(2)") do
      select_dropdown_value(group)
    end
  end

  def select_origin_country(group)
    within("div.origins-region div.measure-origin:nth-child(3)") do
      select_dropdown_value(group)
    end
  end

  def select_quota_period_type(period)
    within("#quota-period-select") do
      select_dropdown(period)
    end
  end

  # def select_dropdown(value)
  #   find(".selectize-control").click
  #   find(".selectize-dropdown-content .option", text: value).click
  # end

  def select_section_duration(duration)
    within("#quota-duration") do
      select_dropdown(duration)
    end
  end

  def select_measurement_unit(unit)
    within("#measurement-unit-code") do
      select_dropdown_value(unit)
    end
  end

  def select_custom_period_measurement_unit(unit)
    within("#measurement-units") do
      select_dropdown_value(unit)
    end
  end

  def select_measurement_qualifier(qualifier)
    within("#measurement-units-qualifier") do
      select_dropdown_value(qualifier)
    end
  end

  def select_monetary_unit(unit)
    within("#monetary-unit-code") do
      select_dropdown(unit)
    end
  end

  def enter_annual_opening_balance(balance)
    quota_section.annual_opening_balance.set balance
  end

  def enter_periods_opening_balances(balance)
    balance_fields = find_all(".opening-balances > div > .form-group:nth-of-type(1) .row input:nth-of-type(1)")
    balance_fields.each {|balance_field| balance_field.set balance}
  end

  def enter_start_date_year(year)
    section_start_date_year.set year
  end

  def enter_custom_period_start_date
    date_fields = find_all(".quota-section .custom-period input.date-picker")
    date_fields.first.set format_date(Date.today)
    # Close the date picker
    find('#footer').click
    date_fields.last.set format_date(random_future_date)
    # Close the date picker
    find('#footer').click
  end

  # Duty Expressions
  def add_duty_expression(duty, quota_period)
    case quota_period
      when 'Custom'
        select_custom_period_duty_expression duty['expression']
        enter_custom_period_duty_amount duty['amount']
      else
        select_duty_expression duty['expression']
        enter_duty_amount duty['amount']
    end
    select_unit_of_measure duty['unit'] unless duty['unit'].nil?
    select_qualifier duty['qualifier'] unless duty['qualifier'].nil?
  end

  def select_duty_expression(duty_expression)
    within("#quota-section-0-measure-component-0-duty-expression") do
      select_dropdown_value(duty_expression)
    end
    end

  def select_custom_period_duty_expression(duty_expression)
    within("#quota-section-0-period-0-measure-component-0-duty-expression") do
      select_dropdown_value(duty_expression)
    end
  end

  def enter_duty_amount(amount)
    quota_section.duty_amount.set amount
    end

  def enter_custom_period_duty_amount(amount)
    quota_section.custom_period_duty_amount.set amount
  end

  def select_unit_of_measure(unit)
    within("#quota-section-0-measure-component-0-measurement-unit") do
      select_dropdown_value(unit)
    end
  end

  def select_qualifier(qualifier)
    within("#quota-section-0-measure-component-0-measurement-unit-qualifier") do
      select_dropdown_value(qualifier)
    end
  end

  def add_conditions(condition_array)
    condition = condition_array.first
    select_condition_type condition['type']
    select_certificate_type condition['certificate_type'] unless condition['certificate_type'].nil?
    select_certificate condition['certificate'] unless condition['certificate'].nil?
    select_condition_action condition['action']
    select_condition_duty_expression condition['duty_expression']
    enter_condition_duty_amount condition['duty_amount']
  end

  def select_condition_type(condition_type)
    within("#measure-condition-0-condition") do
      select_dropdown_value(condition_type)
    end
  end

  def select_certificate_type(certificate_type)
    within("#measure-condition-0-certificate-type") do
      select_dropdown_value(certificate_type)
    end
  end

  def select_certificate(certificate)
    within("#measure-condition-0-certificate") do
      select_dropdown_value(certificate)
    end
  end

  def select_condition_action(action)
    within("#measure-condition-0-action") do
      select_dropdown_value(action)
    end
  end

  def select_condition_duty_expression(duty_expression)
    within("#measure-condition-0-measure-condition-component-0-duty-expression") do
      select_dropdown_value(duty_expression)
    end
  end

  def enter_condition_duty_amount(duty)
    conditions.duty_amount.set duty
  end

  def add_footnote(footnote)
    within("#footnote-0-footnote-type") do
      select_dropdown_value(footnote['type'])
    end
    footnote_text_field.set footnote['id']
    footnote_text_suggestion.click
  end

  def continue
    continue_button.click
  end

  def submit_measure_for_cross_check
    submit_for_crosscheck_button.click
  end

  def view_commodity_code_description(code)
    check_commodity_code_link.click
    check_commodity_code_field.set code
  end

  def view_additional_code_description(code)
    check_additional_code_link.click
    check_additional_code_field.set code
  end
end