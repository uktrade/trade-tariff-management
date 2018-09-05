window.WorkbasketBaseSaveActions =

  toogleSaveSpinner: (mode) ->
    WorkbasketBaseSaveActions.disable_other_buttons(mode)

  disable_other_buttons: (mode) ->
    save_link = $(".js-workbasket-base-save-progress-button")
    submit_link = $(".js-workbasket-base-continue-button")
    exit_link = $(".js-workbasket-base-exit-button")
    previous_link = $(".js-workbasket-base-previous-step-link")
    submit_link.prop('disabled', true)
    save_link.prop('disabled', true)

    save_link.attr("data-original-text", save_link.val())
    submit_link.attr("data-original-text", submit_link.val())

    save_link.val("Saving...")
    submit_link.val("Saving...")

    exit_link.addClass('disabled')
    previous_link.addClass('disabled')

  unlockButtonsAndHideSpinner: ->
    save_link = $(".js-workbasket-base-save-progress-button")
    submit_link = $(".js-workbasket-base-continue-button")

    save_link.val(save_link.data("original-text"))
    submit_link.val(submit_link.data("original-text"))

    $(".js-workbasket-base-submit-button, .js-workbasket-base-exit-button, .js-workbasket-base-previous-step-link").removeClass("disabled").prop('disabled', false)

  handleSuccessResponse: (resp, submit_mode) ->
    WorkbasketBaseValidationErrorsHandler.hideCustomErrorsBlock()

    if resp.redirect_url isnt undefined
      setTimeout (->
        window.location = resp.redirect_url
      ), 1000
    else
      if resp.next_step.length > 0 && submit_mode == 'continue'
        WorkbasketBaseSaveActions.setSpinnerText("Redirecting to next step")

        setTimeout (->
          window.location = window.save_url + '/edit?step=' + resp.next_step
        ), 1000
      else
        WorkbasketBaseSaveActions.showSuccessMessage()
        WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner()

  showSuccessMessage: ->
    $(".js-workbasket-base-success-message-container").removeClass('hidden')

  hideSuccessMessage: ->
    $(".js-workbasket-base-success-message-container").addClass('hidden')

  setSpinnerText: (message) ->
    $(".js-workbasket-base-continue-spinner .saving_message").text(message)
