class AdditionalCodesPage < SitePrism::Page

  element :workbasket, "#additional_code_workbasket_name"
  element :additional_code_type, "#additional_code_type_0"
  elements :code_values, "span.option-prefix"
  element :additional_code, "input#additional_code_code_0.form-control"
  element :additional_code_description, "textarea#additional_code_description_0.form-control"
  element :start_date, "#additional_code_valid_from"
  element :save_button, ".save_progress_block .js-workbasket-base-submit-button"
  element :submit_for_crosscheck_button, "button.button.js-workbasket-base-continue-button.js-workbasket-base-submit-button"


  def enter_workbasket_name(name)
    workbasket.set name
  end

  def enter_start_date(date)
    start_date.set date
  end

   def click_save
     save_button.click
   end
end