class CrossCheckPage < SitePrism::Page

  section :work_basket_details, ".create-measures-details-table" do
    element :work_basket_name, "tr:nth-child(1) td:nth-child(2)"
  end

  section :cross_check_confirmation, '.panel--confirmation' do
    element :header, "h1"
    element :message, "h3"
  end

  element :accept_cross_check_option, "#radioID"
  element :reject_cross_check_option, "#radioID2"
  element :reject_cross_check_reason, "#rejection_reason"
  element :finish_cross_check_button, "input[name='submit_for_cross_check']"

  element :return_to_main_menu, "#wrapper a", text: "Return to main menu"
  element :view_these_measure, "#wrapper a", text: "View these measures"
  element :cross_check_next_workbasket, "#wrapper a", text: "Cross-check next workbasket"

  CROSS_CHECK_REJECTED_HEADER = "Measures cross-check rejected"
  CROSS_CHECK_ACCEPTED_HEADER = "Measures cross-checked."
  CROSS_CHECK_ACCEPTED_MESSAGE = "The measure(s) have been cross-checked but not yet sent through to CDS. They are currently pending approval."


  def accept_cross_check
    accept_cross_check_option.click
    finish_cross_check_button.click
  end

  def reject_cross_check
    reject_cross_check_option.click
    reject_cross_check_reason.set "Automated test. Rejecting the work basket."
    finish_cross_check_button.click
  end
end