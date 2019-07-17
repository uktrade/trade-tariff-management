require_relative '../support/helper'
require_relative 'create_measure_page_elements'

class CreateMeasurePage < CreateMeasurePageElements

    include CapybaraFormHelper

    set_url ENV['MEASURE']

    NO_START_DATE_MESSAGE = "Start date can't be blank!"
    NO_WORKBASKET_NAME_MESSAGE = "Workbasket name can not be blank."
    NO_COMMODITY_CODE_MESSAGE = "Goods commodity codes: can be empty but only if one or more Meursing codes are entered in the Additional codes field."
    NO_REGULATION_MESSAGE = "Regulation cannot be blank. Please enter the regulation that gives legal force to these measures."
    NO_MEASURE_TYPE_MESSAGE = "Measure type cannot be blank. Please enter a measure type."
    NO_ORIGIN_MESSAGE = "Origin cannot be blank. Please enter an origin."
    ME9_ERROR = "ME9: If no additional code is specified then the goods code is mandatory.,{:goods_nomenclature_code=>nil, :additional_code=>nil, :geographical_area_id=>\"\\w+\"}"
    ME4_ERROR = "ME4: The geographical area must exist.,{:goods_nomenclature_code=>nil, :additional_code=>nil, :geographical_area_id=>""}"
    ME27_ERROR = "The entered regulation may not be fully replaced.,{:goods_nomenclature_code=>\"\\w+\", :additional_code=>nil, :geographical_area_id=>\"\\w+\"}"
    ME86_ERROR = "The role of the entered regulation must be a Base, a Modification, a Provisional Anti-Dumping, a Definitive Anti-Dumping.,{:goods_nomenclature_code=>\"\\w+\", :additional_code=>nil, :geographical_area_id=>\"\\w+\"}"
    ME25_ERROR = "ME25: If the measure's end date is specified \\(implicitly or explicitly\\) then the start date of the measure must be less than or equal to the end date.,{:goods_nomenclature_code=>\"\\w+\", :additional_code=>nil, :geographical_area_id=>\"\\w+\"}"
    ME2_ERROR = "ME2: The measure type must exist.,{:goods_nomenclature_code=>\"\\w+\", :additional_code=>nil, :geographical_area_id=>\"\\w+\"}"
    ME88_ERROR = "ME88: The level of the goods code, if present, cannot exceed the explosion level of the measure type.,{:goods_nomenclature_code=>\"\\w+\", :additional_code=>nil, :geographical_area_id=>\"\\w+\"}"
    ME12_ERROR = "ME12: If the additional code is specified then the additional code type must have a relationship with the measure type. { measure_sid=>\"\\w+\" },{:goods_nomenclature_code=>\"\\w+\", :additional_code=>\"\\w+\", :geographical_area_id=>\"\\w+\"}"
    ME1_ERROR = "ME1: The combination of measure type \\+ geographical area \\+ goods nomenclature item id \\+ additional code type \\+ additional code \\+ order number \\+ reduction indicator \\+ start date must be unique.,{:goods_nomenclature_code=>\"\\w+\", :additional_code=>nil, :geographical_area_id=>\"\\w+\"}"
    ME32_ERROR = ""

    def continue
      continue_button.click
    end

    def save_progress
      save_button.click
    end

    def exit
      exit_link.click
    end

    def previous
      previous_step_link.click
    end

    def find_or_edit_existing_measure
      find_edit_existing_measures_link
    end

    def enter_measure_start_date(date)
      measure_validity_start_date.set format_date(date)
      # click anywhere to close the datepicker
      find("body").click
    end

    def enter_measure_end_date(date)
      measure_validity_end_date.set format_date(date)
      # click anywhere to close the datepicker
      find('#footer').click
    end

    def select_regulation(reg)
      regulation_dropdown.click
      regulation_dropdown.set reg
      regulations_options.first.click
    end

    def select_measure_type_series(measure_type_series)
      within(".workbasket_forms_create_measures_form_measure_type_series_id") do
        select_dropdown_value(measure_type_series)
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

    def select_measure_type(measure_type)
      within(".workbasket_forms_create_measures_form_measure_type_id") do
        select_dropdown_value(measure_type)
      end
    end

    def add_footnote(footnote)
      within("#footnote-0-footnote-type") do
        select_dropdown_value(footnote['type'])
      end
      footnote_text_field.set footnote['id']
      footnote_text_suggestion.click
    end

    def enter_workbasket_name(workbasket)
      workbasket_name.set workbasket
    end

    def enter_commodity_codes(commodity_codes)
      commodity_code.set commodity_codes
    end

    def enter_exceptions(exception)
      exceptions.set exception
    end

    def enter_additional_codes(additional_code)
      additional_codes.set additional_code
    end

    def enter_reduction_indicator(indicator)
      additional_codes.set indicator if [1,2,3].include? indicator.to_i
    end

    def select_erga_omnes
      erga_omnes_radio_button.click
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

    def select_country_group(group)
      country_groups_radio_button.click
      country_groups_dropdown.click
      country_groups_dropdown.set group
      country_groups_options.first.click
    end

    def select_country(country)
      country_region_radio_button.click
      country_region_dropdown.click
      country_region_dropdown.set country
      country_groups_options.first.click
    end

    # Conditions
    def add_conditions(condition_array)
      condition_array.each do |condition|
        index = condition_array.find_index(condition)
        select_condition_type condition['type'], index
        select_certificate_type condition['certificate_type'], index unless condition['certificate_type'].nil?
        select_certificate condition['certificate'], index unless condition['certificate'].nil?
        select_condition_action condition['action'], index
        select_condition_duty_expression condition['duty_expression'], index
        enter_condition_duty_amount condition['duty_amount'], index
        add_more_conditions
      end
    end

    def select_condition_type(condition_type, index)
      position = index
      within("#measure-condition-#{position}-condition") do
        select_dropdown_value(condition_type)
      end
    end

    def select_certificate_type(certificate_type, index)
      position = index
      within("#measure-condition-#{position}-certificate-type") do
        select_dropdown_value(certificate_type)
      end
    end

    def select_certificate(certificate, index)
      position = index
      within("#measure-condition-#{position}-certificate") do
        select_dropdown_value(certificate)
      end
    end

    def select_condition_action(action, index)
      position = index
      within("#measure-condition-#{position}-action") do
        select_dropdown_value(action)
      end
    end

    def select_condition_duty_expression(duty_expression, index)
      position = index
      within("#measure-condition-#{position}-measure-condition-component-0-duty-expression") do
        select_dropdown_value(duty_expression)
      end
    end

    def enter_condition_duty_amount(duty, index)
      position = index
      find("#measure-condition-#{position}-measure-condition-component-0-amount").set duty
    end

    def add_more_conditions
      add_another_condition.click
    end

    # Duty Expressions
    def add_duty_expression(duty)
      select_duty_expression duty['expression']
      enter_duty_amount duty['amount'] unless duty['amount'].nil?
      select_unit_of_measure duty['unit'] unless duty['unit'].nil?
      select_qualifier duty['qualifier'] unless duty['qualifier'].nil?
    end

    def select_duty_expression(duty_expression)
      within("#measure-component-0-duty-expression") do
        select_dropdown_value(duty_expression)
      end
    end

    def enter_duty_amount(amount)
      duty_expressions.duty_amount.set amount
    end

    def select_unit_of_measure(unit)
      within("#measure-component-0-measurement-unit") do
        select_dropdown_value(unit)
      end
    end

    def select_qualifier(qualifier)
      within("#measure-component-0-measurement-unit-qualifier") do
        select_dropdown_value(qualifier)
      end
    end

    def submit_measure_for_cross_check
      submit_for_crosscheck_button.click
    end

    def return_to_main_menu
      exit_link.click
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