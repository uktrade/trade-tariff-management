class CreateMeasurePageElements < SitePrism::Page

  element :find_edit_existing_measures_link, ".heading-large a"
  element :measure_validity_start_date, "#measure_validity_start_date"
  element :measure_validity_end_date, :xpath, "//form/fieldset[2]//input"
  element :regulation_dropdown, "#wrapper fieldset:nth-child(6) .selectize-control input"
  elements :regulations_options, ".selectize-dropdown-content .option"
  element :measure_type_series, ".workbasket_forms_create_measures_form_measure_type_series_id div"
  element :measure_type_series_options, ".workbasket_forms_create_measures_form_measure_type_series_id .selectize-dropdown-content span"
  element :measure_type, ""
  elements :measure_type_options, ""
  element :workbasket_name, "#workbasket_name"
  element :commodity_code, "#commodity_codes"
  element :exceptions, "#exceptions"
  element :additional_codes, :xpath, "//form/fieldset[7]//textarea"
  element :reduction_indicator, "input.single-digit-field"
  element :erga_omnes_radio_button, ".origins-region #measure-origin-erga_omnes"
  element :country_groups_radio_button, ".origins-region #measure-origin-group"
  element :country_groups_dropdown, "div.origins-region div.measure-origin:nth-child(2) .selectize-control"
  elements :country_groups_options, "div.origins-region div.measure-origin:nth-child(2) .selectize-dropdown-content span"

  element :country_region_radio_button, ".origins-region #measure-origin-country"
  element :country_region_dropdown, "div.origins-region div.measure-origin:nth-child(3) .selectize-control"
  elements :country_region_options, "div.origins-region div.measure-origin:nth-child(3) .selectize-dropdown-content span"

  section :conditions, "#wrapper fieldset:nth-child(5)" do
    element :condition, "#measure-condition-0-condition .selectize-control"
    elements :condition_options, "#measure-condition-0-condition .selectize-control .selectize-dropdown-content .selection"
    element :certificate_type, "#measure-condition-0-certificate-type .selectize-control"
    elements :certificate_type_options, "#measure-condition-0-certificate-type .selectize-control .selectize-dropdown-content .selection"
    element :certificate, "#measure-condition-0-certificate .selectize-control"
    elements :certificate_options, "#measure-condition-0-certificate .selectize-control .selectize-dropdown-content .selection"
    element :action, "#measure-condition-0-action .selectize-control"
    elements :action_options, "#measure-condition-0-action .selectize-control .selectize-dropdown-content .selection"
    element :duty_expression, "#measure-condition-0-measure-condition-component-0-duty-expression .selectize-control"
    elements :duty_expression_options, "#measure-condition-0-measure-condition-component-0-duty-expression .selectize-control .selectize-dropdown-content .selection"
    element :duty_amount, "#measure-condition-0-measure-condition-component-0-amount"
  end

  section :duty_expressions, "#wrapper fieldset:nth-child(4) .measure-components" do
    element :add_duty_expression_link, "a"
    element :duty_expression_dropdown, "#measure-component-0-duty-expression .selectize-input"
    elements :duty_expression_options, "#measure-component-0-duty-expression .selectize-dropdown .selection"
    element :duty_amount, "#measure-component-0-amount"
    element :unit_of_measure_dropdown, "#measure-component-0-measurement-unit .selectize-input"
    elements :unit_of_measure_options, "#measure-component-0-measurement-unit .selectize-dropdown .selection"
    element :qualifier_dropdown, "#measure-component-0-measurement-unit-qualifier .selectize-input"
    elements :qualifier_options, "#measure-component-0-measurement-unit-qualifier .selectize-dropdown .selection"
  end

  element :footnote_dropdown, "#wrapper fieldset:nth-child(6) .selectize-control"
  element :footnote_options, "#wrapper fieldset:nth-child(6) .selectize-dropdown-content .selection"
  element :footnote_text_field, "#footnote-0-footnote"
  element :footnote_text_suggestion, "#footnote-0-suggestion-0-use-button"
  element :add_footnote_link, "div.footnote .selectize-input input"

  section :measure_summary, '.create-measures-details-table' do
    element :workbasket_name, "tr:nth-child(1) td:nth-child(2)"
    element :operation_date, "tr:nth-child(2) td:nth-child(2)"
    element :regulation, "tr:nth-child(3) td:nth-child(2)"
    element :start_date, "tr:nth-child(4) td:nth-child(2)"
    element :end_date, "tr:nth-child(5) td:nth-child(2)"
    element :type, "tr:nth-child(6) td:nth-child(2)"
    element :goods, "tr:nth-child(7) td:nth-child(2)"
    element :goods_exceptions, "tr:nth-child(8) td:nth-child(2)"
    element :additional_codes, "tr:nth-child(9) td:nth-child(2)"
    element :origin, "tr:nth-child(10) td:nth-child(2)"
    element :origin_exceptions, "tr:nth-child(11) td:nth-child(2)"
  end

  section :measures_to_be_created, '.records-table .item-container' do
    elements :commodity_codes, ".goods_nomenclature-column"
    elements :additional_codes, ".additional_code-column"
    elements :start_date, ".validity_start_date-column"
    elements :end_date, ".validity_end_date-column"
    elements :duties, ".duties-column"
    elements :conditions, ".conditions-column"
    elements :footnotes, ".footnotes-column"
  end

  section :confirm_submission, '.panel--confirmation' do
    element :header, "h1", text: "Measures submitted"
    element :message, "h3"
  end

  element :save_button, "input[name='save_progress']"
  element :continue_button, "input[name='continue']"
  element :exit_link, "a.js-workbasket-base-exit-button"
  element :previous_step_link, "a[class$='previous-step-link']"
  element :submit_for_crosscheck_button, "input[name='submit_for_cross_check']"

  section :error_summary, "div.js-custom-errors-block" do
    elements :errors, "li div"
  end
end