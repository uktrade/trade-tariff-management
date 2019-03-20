require_relative '../support/helper'
require_relative 'create_measure_page_elements'

class CreateMeasurePage < CreateMeasurePageElements

    include CapybaraFormHelper

    set_url ENV['MEASURE']

    NO_START_DATE_MESSAGE = "Start date can't be blank!"
    NO_WORKBASKET_NAME_MESSAGE = "Workbasket name can not be blank."
    NO_COMMODITY_CODE_MESSAGE = "Goods commodity codes: can be empty but only if one or more Meursing codes are entered in the Additional codes field."
    ME9_ERROR = "ME9: If no additional code is specified then the goods code is mandatory.,{:goods_nomenclature_code=>nil, :additional_code=>nil, :geographical_area_id=>\"\\w+\"}"
    ME4_ERROR = "ME4: The geographical area must exist.,{:goods_nomenclature_code=>nil, :additional_code=>nil, :geographical_area_id=>""}"
    ME27_ERROR = "The entered regulation may not be fully replaced.,{:goods_nomenclature_code=>\"\\w+\", :additional_code=>nil, :geographical_area_id=>\"\\w+\"}"
    ME86_ERROR = "The role of the entered regulation must be a Base, a Modification, a Provisional Anti-Dumping, a Definitive Anti-Dumping.,{:goods_nomenclature_code=>\"\\w+\", :additional_code=>nil, :geographical_area_id=>\"\\w+\"}"
    ME25_ERROR = "ME25: If the measure's end date is specified \\(implicitly or explicitly\\) then the start date of the measure must be less than or equal to the end date.,{:goods_nomenclature_code=>\"\\w+\", :additional_code=>nil, :geographical_area_id=>\"\\w+\"}"
    ME2_ERROR = "ME2: The measure type must exist.,{:goods_nomenclature_code=>\"\\w+\", :additional_code=>nil, :geographical_area_id=>\"\\w+\"}"
    ME88_ERROR = "ME88: The level of the goods code, if present, cannot exceed the explosion level of the measure type.,{:goods_nomenclature_code=>\"\\w+\", :additional_code=>nil, :geographical_area_id=>\"\\w+\"}"
    ME12_ERROR = "ME12: If the additional code is specified then the additional code type must have a relationship with the measure type. { measure_sid=>\"\\w+\" },{:goods_nomenclature_code=>\"\\w+\", :additional_code=>\"\\w+\", :geographical_area_id=>\"\\w+\"}"


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
      find("body").click
    end

    def enter_measure_end_date(date)
      measure_validity_end_date.set format_date(date)
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
      within("#wrapper fieldset:nth-child(6)") do
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
    def add_conditions(condition)
      select_condition_type condition['type']
      select_certificate_type condition['certificate_type'] unless condition['certificate_type'].nil?
      select_certificate condition['certificate'] unless condition['certificate'].nil?
      select_condition_action condition['action']
      select_condition_duty_expression condition['duty_expression']
      enter_condition_duty_amount condition['duty_amount']
    end

    def select_condition_type(condition_type)
      within("#wrapper fieldset:nth-child(5) #measure-condition-0-condition") do
        select_dropdown_value(condition_type)
      end
    end

    def select_certificate_type(certificate_type)
      within("#wrapper fieldset:nth-child(5) #measure-condition-0-certificate-type") do
        select_dropdown_value(certificate_type)
      end
    end

    def select_certificate(certificate)
      within("#wrapper fieldset:nth-child(5) #measure-condition-0-certificate") do
        select_dropdown_value(certificate)
      end
    end

    def select_condition_action(action)
      within("#wrapper fieldset:nth-child(5) #measure-condition-0-action") do
        select_dropdown_value(action)
      end
    end

    def select_condition_duty_expression(duty_expression)
      within("#wrapper fieldset:nth-child(5) #measure-condition-0-measure-condition-component-0-duty-expression") do
        select_dropdown_value(duty_expression)
      end
    end

    # Duty Expressions
    def add_duty_expression(duty)
      select_duty_expression duty['expression']
      enter_duty_amount duty['amount']
      select_unit_of_measure duty['unit'] unless duty['unit'].nil?
      select_qualifier duty['qualifier'] unless duty['qualifier'].nil?
    end

    def select_duty_expression(duty_expression)
      within("#wrapper fieldset:nth-child(4) .measure-components #measure-component-0-duty-expression") do
        select_dropdown_value(duty_expression)
      end
    end

    def enter_duty_amount(amount)
      duty_expressions.duty_amount.set amount
    end

    def select_unit_of_measure(unit)
      within("#wrapper fieldset:nth-child(4) .measure-components #measure-component-0-measurement-unit") do
        select_dropdown_value(unit)
      end
    end

    def select_qualifier(qualifier)
      within("#wrapper fieldset:nth-child(4) .measure-components #measure-component-0-measurement-unit-qualifier") do
        select_dropdown_value(qualifier)
      end
    end

    def return_tomain_menu

    end

    def enter_condition_duty_amount(duty)
      conditions.duty_amount.set duty
    end

    def submit_measure_for_cross_check
      submit_for_crosscheck_button.click
    end
end