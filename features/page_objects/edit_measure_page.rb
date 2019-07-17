require_relative '../support/helper'

class EditMeasurePage < SitePrism::Page

  include CapybaraFormHelper

  element :start_date, "input.date-picker"
  element :regulation, ".selectize-control"
  element :not_from_regulation_checkbox, "#not-from-regulation"
  element :reason_for_change, "#reason"
  element :workbasket_name, "input[name='title']"
  element :proceed_button, ".button"
  element :submit_for_crosscheck_button, ".js-bulk-edit-of-records-submit-for-cross-check"
  element :save_progress_button, ".js-bulk-edit-of-records-save-progress"
  element :bulk_action_dropdown, ".button-dropdown:nth-of-type(1) button"
  elements :bulk_action_options, ".button-dropdown:nth-of-type(1) li"
  element :selected_measure_alert, ".alert--info"

  element :ok_button, "#bem-save-progress-summary a.button", text: "OK"
  element :no_conformance_errors, ".alert .js-bem-popup-data-container", text: "There are no conformance errors"
  element :progress_saved, "h2.modal__title", text: "Your progress successfully saved!"

  section :bulk_edit_popup, "#modal-1 .modal__container" do
    element :erga_omnes_radio_button, ".origins-region #measure-origin-erga_omnes"
    element :country_groups_radio_button, ".origins-region #measure-origin-group"
    element :country_region_radio_button, ".origins-region #measure-origin-country"
    element :duty_amount, "#measure-component-0-amount"
    elements :commodity_code_fields, "input[id^='commodity_code_input_']"
    element :additional_code, ".text-input-wrapper input"
    element :remove_additional_code_checkbox, ".multiple-choice input"
    element :updated_selected_measures_button, ".button", text: "Update selected measures"
    element :add_to_existing_footnotes, "#add-to-any-existing"
    element :replace_existing_footnotes, "#replace-any-existing"
    element :footnote_type, "#footnote-0-footnote-type"
    element :footnote_field, "#footnote-0-footnote"
    element :use_this_footnote, "#footnote-0-suggestion-0-use-button"
  end

  sections :bulk_edit_measures, "div.records-table div.table__row" do
    element :select, ".select-all-column input"
    element :id, ".measure_sid-column"
    element :type, ".measure_type_id-column"
    element :regulation, ".regulation-column"
    element :justification_regulation, ".justification_regulation-column"
    element :start_date, ".validity_start_date-column"
    element :end_date, ".validity_end_date-column"
    element :commodity_code, ".goods_nomenclature-column"
    element :additional_code, ".additional_code-column"
    element :origin, ".geographical_area-column"
    element :origin_exclusions, ".excluded_geographical_areas-column"
    element :duties, ".duties-column"
    element :conditions, ".conditions-column"
    element :footnotes, ".footnotes-column"
    element :last_updated, ".last_updated-column"
    element :status, ".status-column"
  end

  section :edit_measures_summary, ".create-measures-details-table tbody" do
    element :workbasket_name, "tr:nth-child(1) td:nth-child(2)"
    element :operation_date, "tr:nth-child(2) td:nth-child(2)"
    element :reason_for_change, "tr:nth-child(3) td:nth-child(2)"
    element :regulation, "tr:nth-child(4) td:nth-child(2)"
  end

  section :confirm_submission, '.panel--confirmation' do
    element :header, "h1", text: "Measures submitted"
    element :message, "h3"
  end

  def enter_change_start_date(date)
    start_date.set format_date(date)
    find("body").click
  end

  def select_regulation(reg)
    within(regulation) do
      search_for_value(type_value: reg, select_value: reg)
    end
  end

  def not_from_regulation
    not_from_regulation_checkbox.click
  end

  def enter_reason_for_change(reason)
    reason_for_change.set reason
  end

  def enter_workbasket_name(workbasket)
    workbasket_name.set workbasket
  end

  def proceed
    proceed_button.click
  end

  def submit_for_crosscheck
    submit_for_crosscheck_button.click
  end

  def save_progress
    save_progress_button.click
  end

  def select_bulk_action(bulk_action)
    bulk_action_dropdown.click
    bulk_action_options.each do |action|
      action.click if action.text.include? bulk_action
    end
  end

  def select_origin(origin)
    case origin['type']
      when 'erga_omnes'
        bulk_edit_popup.erga_omnes_radio_button.click
      when 'group'
        bulk_edit_popup.country_groups_radio_button.click
        select_origin_group origin['name']
      when 'country'
        bulk_edit_popup.country_region_radio_button.click
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

  def updated_selected_measures
    bulk_edit_popup.updated_selected_measures_button.click
  end

  def add_duty_expression(duty)
    select_duty_expression duty['expression']
    enter_duty_amount duty['amount'] unless duty['amount'].nil?
  end

  def select_duty_expression(duty_expression)
    within("#measure-component-0-duty-expression") do
      select_dropdown_value(duty_expression)
    end
  end

  def enter_duty_amount(amount)
    bulk_edit_popup.duty_amount.set amount
  end

  def enter_commodity_code(code)
    bulk_edit_popup.commodity_code_fields.each {|field| field.set code}
  end

  def ok_no_conformance_errors
    ok_button.click
  end

  def enter_additional_code(code)
    bulk_edit_popup.additional_code.set code
  end

  def enter_start_date(date)
    find_all("input.date-picker").first.set format_date date
    find("body").click
  end

  def enter_end_date(date)
    find_all("input.date-picker").last.set format_date date
    find("body").click
  end

  def add_to_footnotes
    bulk_edit_popup.add_to_existing_footnotes.click
  end

  def replace_footnotes
    bulk_edit_popup.replace_existing_footnotes.click
  end

  def add_footnote(footnote)
    within(bulk_edit_popup.footnote_type) do
      select_dropdown_value(footnote['type'])
    end
    bulk_edit_popup.footnote_field.set footnote['id']
    bulk_edit_popup.use_this_footnote.click
    if bulk_edit_popup.has_replace_existing_footnotes?
      replace_footnotes
    end
  end

  def add_conditions(condition_array)
    condition_array.each do |condition|
      index = condition_array.find_index(condition)
      select_condition_type condition['type'], index
      select_certificate_type condition['certificate_type'], index unless condition['certificate_type'].nil?
      select_certificate condition['certificate'], index unless condition['certificate'].nil?
      select_condition_action condition['action'], index
      select_condition_duty_expression condition['duty_expression'], index
      enter_condition_duty_amount condition['duty_amount'], index
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

  def selected_measures_alert
    selected_measure_alert.text
  end
end