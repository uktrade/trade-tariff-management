
class FindMeasurePage < SitePrism::Page

  include CapybaraFormHelper

  element :measure_sid, "div.find-items__row:nth-of-type(1) div.find-item__long input"
  element :group_name, "div.find-items__row:nth-of-type(2) div.find-item__long input"
  element :commodity_code, "div.find-items__row:nth-of-type(7) div.find-item__short input"
  element :additional_code, "div.find-items__row:nth-of-type(8) div.find-item__short input"
  element :regulation, "div.find-items__row:nth-of-type(4) div.find-item__short input"
  element :search_button, "div.form-actions button"
  element :clear, "div.form-actions a"
  element :select_all, ".table__header .select-all-column input"
  elements :select_one,  "div.table__column.select-all-column input"
  element :work_with_selected_measures, ".clearfix .button", text: "Work with selected measures"

  section :measure_type, "div.find-items__row:nth-of-type(3) div.find-item__short" do
    element :input, "input"
    elements :options, ".selectize-dropdown-content .selection"
  end

  sections :measure_search_results, "div.measures-table div.table__row" do
    element :lock, ".locked-column span i"
    element :select, ".select-all-column input"
    element :id, ".measure_sid-column"
    element :type, ".measure_type_id-column"
    element :regulation, ".regulation-column"
    element :starts, ".validity_start_date-column"
    element :ends, ".validity_end_date-column"
    element :commodity_code, ".goods_nomenclature_id-column"
    element :additional_code, ".additional_code_id-column"
    element :origin, ".geographical_area-column"
    element :origin_exclusions, ".excluded_geographical_areas-column"
    element :duties, ".duties-column"
    element :conditions, ".conditions-column"
    element :footnotes, ".footnotes-column"
    element :last_updated, ".last_updated-column"
    element :status, ".status-column"

  end

  def enter_measure_type(type)
    measure_type.input.set type
  end

  def find_measure(workbasket)
    group_name.set workbasket
    search_button.click
  end

  def find_measure_by_type(measure_type)
    within("div.find-items__row:nth-of-type(3) div.find-item__short") do
      search_for_value(measure_type)
    end
    search_button.click
  end

  def find_measure_by_sid(sid)
    if sid.size < 7
      filter_by_contains
      measure_sid.set sid
    else
      measure_sid.set sid
    end
    search_button.click
  end

  def deselect_all_measures
    select_all.click
  end

  def press_work_with_selected_measures
    work_with_selected_measures.click
  end

  def filter_by_contains
    measure_sid_dropdown = find_all(".find-items__is").first
    within(measure_sid_dropdown) do
      select_dropdown("contains")
    end
  end
end