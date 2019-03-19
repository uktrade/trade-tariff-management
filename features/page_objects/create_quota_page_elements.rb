class CreateQuotaPageElements < SitePrism::Page

  element :regulation_dropdown, ""
  element :quota_order_number_field, ""
  element :maximun_precision_dropdown, ""
  element :quota_type_drpdown, ""
  element :quota_description_field, ""
  element :operation_date_field, ""
  element :commodity_codes_field, ""
  element :exceptions, ""
  element :additional_codes, ""
  element :reduction_indicator, ""

  element :erga_omnes, ""

  section :licensed_quota, "" do
    element :check_box, ""
    element :quota_licence_dropdown, ""
  end

  section :quota_section, "" do
    element :period_type, ""
    element :start_date, ""
    element :duration, ""
    element :section_staged_checkbox, ""
    element :different_criticality_checkbox, ""
    element :different_duty_checkbox, ""
    element :measurement_unit, ""
    element :qualifier, ""
    element :monetary_unit, ""
    element :opening_balance, ""
    element :start_quota_critical_checkbox, ""
    element :quota_criticality_threshold_checkbox, ""
    element :duty_expression, ""
    element :duty_amount, ""
  end

  section :conditions, "" do
    element :duty_amount, ""
  end

  element :footnote_dropdown, "#wrapper fieldset:nth-child(6) .selectize-control"
  element :footnote_options, "#wrapper fieldset:nth-child(6) .selectize-dropdown-content .selection"
  element :footnote_text_field, "#footnote-0-footnote"
  element :footnote_text_suggestion, "#footnote-0-suggestion-0-use-button"
  element :add_footnote_link, ""

  section :quota_summary, '.create-measures-details-table' do
    element :order_number, "tr:nth-child(1) td:nth-child(2)"
    element :maximum_precision, "tr:nth-child(2) td:nth-child(2)"
    element :type, "tr:nth-child(3) td:nth-child(2)"
    element :operation_date, "tr:nth-child(4) td:nth-child(2)"
    element :licensed, "tr:nth-child(5) td:nth-child(2)"
    element :regulation, "tr:nth-child(6) td:nth-child(2)"
    element :goods, "tr:nth-child(7) td:nth-child(2)"
    element :goods_exceptions, "tr:nth-child(8) td:nth-child(2)"
    element :additional_codes, "tr:nth-child(9) td:nth-child(2)"
    element :origin, "tr:nth-child(10) td:nth-child(2)"
    element :origin_exceptions, "tr:nth-child(11) td:nth-child(2)"
    element :conditions, "tr:nth-child(12) td:nth-child(2)"
    element :footnotes, "tr:nth-child(13) td:nth-child(2)"
  end

  section :quotas_to_be_created, '.records-table .item-container' do
    elements :start_date, ".validity_start_date-column"
    elements :end_date, ".validity_end_date-column"
    elements :opening_balance, ".duties-column"
    elements :critical, ".conditions-column"
    elements :criticality_threshold, ".footnotes-column"
  end

  section :measures_to_be_created, '.records-table .item-container' do
    elements :start_date, ".validity_start_date-column"
    elements :end_date, ".validity_end_date-column"
    elements :commodity_codes, ".goods_nomenclature-column"
    elements :additional_codes, ".additional_code-column"
    elements :geographical_area, ".geographical_area-column"
    elements :duties, ".duties-column"
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
end