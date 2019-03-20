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

    def select_measure_type(measure_type)
      within(".workbasket_forms_create_measures_form_measure_type_id") do
        select_dropdown_value(measure_type)
      end
    end

    def enter_workbasket_name(workbasket)
      workbasket_name.set workbasket
    end

    def enter_commodity_codes(commodity_codes)
      commodity_code.set commodity_codes
    end

    def enter_exceptions(exceptions)
      exceptions.set exceptions
    end

    def enter_additional_codes(additional_codes)
      additional_codes.set additional_codes
    end

    def enter_reduction_indicator(indicator)
      additional_codes.set indicator if [1,2,3].include? indicator.to_i
    end

    def select_erga_omnes
      erga_omnes_radio_button.click
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

    def add_footnote(footnote)
      footnotes.footnote_dropdown[0].click
      footnotes.footnote_dropdown[0].set footnote
      footnotes.footnote_dropdown[0].footnote_options.first.click
    end

    def add_conditions(condition)

    end

    def add_duty_expression(duty)
      duty_expressions.duty_expression_dropdown.click
      duty_expressions.duty_expression_options.first.click
      duty_expressions.duty_amount.set duty
    end

    def format_date(date)
      date.strftime("%d/%m/%Y")
    end
end