window.WorkbasketSubmitSpinnerSupport =

  showSpinnerAndLockSubmissionButtons: (submitted_button) ->
    WorkbasketBaseSaveActions.toogleSaveSpinner(submitted_button.attr('name'))
    WorkbasketSubmitSpinnerSupport.showSpinner()

  hideSpinnerAndUnlockSubmissionButtons: () ->
    WorkbasketSubmitSpinnerSupport.hideSpinner()
    WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner()

  showSpinner: () ->
    $(".js-workbasket-base-submit-button").addClass('hidden')
    $(".js-workbasket-base-continue-spinner").removeClass('hidden')

  hideSpinner: () ->
    $(".js-workbasket-base-submit-button").removeClass('hidden')
    $(".js-workbasket-base-continue-spinner").addClass('hidden')
