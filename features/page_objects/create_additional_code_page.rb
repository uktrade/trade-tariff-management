class CreateAdditionalCodePage < SitePrism::Page

  include CapybaraFormHelper

  element :workbasket_name, "#additional_code_workbasket_name"
  element :start_date, "#start_date"
  element :end_date, "#end_date"
  element :submit_for_cross_check_button, "button.js-workbasket-base-continue-button"
  element :save_progress_button, "button.js-workbasket-base-save-progress-button"

  section :confirm_submission, '.panel--confirmation' do
    element :header, "h1", text: "New additional codes submitted"
    element :message, "h3"
  end


  def enter_workbasket_name(workbasket)
    workbasket_name.set workbasket
  end

  def enter_start_date(date)
    start_date.set format_date(date)
    find("body").click
  end

  def enter_end_date(date)
    end_date.set format_date(date)
    find("body").click
  end

  def add_additional_code(additional_codes)
    additional_codes.each do |code|
      index = additional_codes.find_index(code)
      select_type code['type'], index
      enter_three_character_code random_number(3), index
      enter_code_descritpion code['description'], index
    end
  end

  def select_type(type, index)
    within(".additional-code-row #additional_code_type_#{index}") do
      select_dropdown_value(type)
    end
  end

  def enter_three_character_code(code, index)
    find(".additional-code-row #additional_code_code_#{index}").set code
  end

  def enter_code_descritpion(description, index)
    find(".additional-code-row #additional_code_description_#{index}").set description
  end

  def submit_for_cross_check
    submit_for_cross_check_button.click
  end

  def save_progress
    save_progress_button.click
  end
end