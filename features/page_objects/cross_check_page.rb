class CrossCheckPage < SitePrism::Page

  section :work_basket_details, :xpath, '//table[@class="create-measures-details-table"][1]' do
    element :work_basket_name, "tr:nth-child(1) td:nth-child(2)"
  end

  section :configuration_summary, :xpath, '//table[@class="create-measures-details-table"][2]' do
    element :regulation, "tr:nth-child(1) td:nth-child(2)"
    element :start_date, "tr:nth-child(2) td:nth-child(2)"
  end

  section :cross_check_confirmation, '.panel--confirmation' do
    element :header, "h1"
    element :message, "h3"
  end

  element :accept_cross_check_option, "#radioID"
  element :reject_cross_check_option, "#radioID2"
  element :reject_cross_check_reason, "#rejection_reason"
  element :accept_approval_option, "#approve-decision-approve"
  element :reject_approval_option, "#approve-decision-reject"
  element :reject_approval_reason, "#approve_reject_reasons"

  element :finish_cross_check_button, "input[name='submit_for_cross_check']"
  element :return_to_main_menu, "#next-steps a", text: "Return to main menu"
  element :view_these_measure, "#next-steps a", text: "View these measures"
  element :cross_check_next_workbasket, "#next-steps a", text: "Cross-check next workbasket"
  element :approve_next_workbasket, "#next-steps a", text: "Approve next workbasket"

  CROSS_CHECK_REJECTED_HEADER = "Measures cross-check rejected"
  CROSS_CHECK_ACCEPTED_HEADER = "Measures cross-checked."
  CROSS_CHECK_ACCEPTED_MESSAGE = "The measure(s) have been cross-checked but not yet sent through to CDS. They are currently pending approval."

  APPROVAL_ACCEPTED_HEADER = "Measures approved"
  APPROVAL_REJECTED_HEADER = "Measures rejected"
  APPROVAL_REJECTED_MESSAGE = "You declined to approve the measures in workbasket"


  def accept_cross_check
    accept_cross_check_option.click
    finish_cross_check_button.click
  end

  def reject_cross_check
    reject_cross_check_option.click
    reject_cross_check_reason.set "Automated test. Cross check rejected."
    finish_cross_check_button.click
  end

  def accept_approval
    accept_approval_option.click
    finish_cross_check_button.click
  end

  def reject_approval
    reject_approval_option.click
    reject_approval_reason.set "Automated test. Approval rejected."
    finish_cross_check_button.click
  end
end