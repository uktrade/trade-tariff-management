window.WorkbasketBaseSaveActions =

  init: ->
    $(document).on 'click', '.js-workbasket-base-continue-button', ->
      window.workbasket_submit_mode = 'continue'

      return false

    $(document).on 'click', '.js-workbasket-base-save-progress-button', ->
      window.workbasket_submit_mode = 'save_progress'

      return false

  toogleSaveSpinner: (mode) ->
    WorkbasketBaseSaveActions.disable_other_buttons(mode)

    if mode == "save_progress"
      link = $(".js-workbasket-base-save-progress-button")
      spinner = $(".js-workbasket-base-save-progress-spinner")
    else
      link = $(".js-workbasket-base-continue-button")
      spinner = $(".js-workbasket-base-continue-spinner")

    if link.hasClass('hidden')
      spinner.addClass('hidden')
      link.addClass('secondary-button')
      link.removeClass('hidden')
    else
      link.removeClass('secondary-button')
      link.addClass('hidden')
      spinner.removeClass('hidden')

  disable_other_buttons: (mode) ->
    save_link = $(".js-workbasket-base-save-progress-button")
    submit_link = $(".js-workbasket-base-continue-button")
    exit_link = $(".js-workbasket-base-exit-button")
    previous_link = $(".js-workbasket-base-previous-step-link")

    if mode == "save_progress"
      submit_link.addClass('disabled')
    else
      save_link.addClass('disabled')

    exit_link.addClass('disabled')
    previous_link.addClass('disabled')

  unlockButtonsAndHideSpinner: ->
    $(".spinner_block").addClass('hidden')
    $(".js-workbasket-base-submit-button, .js-workbasket-base-exit-button, .js-workbasket-base-previous-step-link").removeClass('disabled')
                                                                                                                      .removeClass('hidden')

  handleSuccessResponse: (resp) ->
    WorkbasketBaseValidationErrorsHandler.hideCustomErrorsBlock()

    if resp.redirect_url isnt undefined
      setTimeout (->
        window.location = resp.redirect_url
      ), 1000
    else
      if resp.next_step.length > 0 && window.workbasket_submit_mode == 'continue'
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

$ ->
  WorkbasketBaseSaveActions.init()
