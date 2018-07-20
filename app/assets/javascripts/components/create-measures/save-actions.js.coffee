window.CreateMeasuresSaveActions =

  init: ->
    $(document).on 'click', '.js-create-measures-continue-button', ->
      window.create_measures_mode = 'continue'

      return false

    $(document).on 'click', '.js-create-measures-save-progress-button', ->
      window.create_measures_mode = 'save_progress'

      return false

  toogleSaveSpinner: (mode) ->
    CreateMeasuresSaveActions.disable_other_buttons(mode)

    if mode == "save_progress"
      link = $(".js-create-measures-save-progress-button")
      spinner = $(".js-create-measures-save-progress-spinner")
    else
      link = $(".js-create-measures-continue-button")
      spinner = $(".js-create-measures-continue-spinner")

    if link.hasClass('hidden')
      spinner.addClass('hidden')
      link.addClass('secondary-button')
      link.removeClass('hidden')
    else
      link.removeClass('secondary-button')
      link.addClass('hidden')
      spinner.removeClass('hidden')

  disable_other_buttons: (mode) ->
    save_link = $(".js-create-measures-save-progress-button")
    submit_link = $(".js-create-measures-continue-button")
    exit_link = $(".js-create-measures-exit-button")
    previous_link = $(".js-create-measures-previous-step-link")

    if mode == "save_progress"
      submit_link.addClass('disabled')
    else
      save_link.addClass('disabled')

    exit_link.addClass('disabled')
    previous_link.addClass('disabled')

  unlockButtonsAndHideSpinner: ->
    $(".spinner_block").addClass('hidden')
    $(".js-create-measures-v2-submit-button, .js-create-measures-exit-button, .js-create-measures-previous-step-link").removeClass('disabled')
                                                                                                                      .removeClass('hidden')

  handleSuccessResponse: (resp) ->
    CreateMeasuresValidationErrorsHandler.hideCustomErrorsBlock()

    if resp.redirect_url isnt undefined
      setTimeout (->
        window.location = resp.redirect_url
      ), 1000
    else
      if resp.next_step.length > 0 && window.create_measures_mode == 'continue'
        CreateMeasuresSaveActions.showSuccessMessage()
        CreateMeasuresSaveActions.setSpinnerText("Redirecting to next step")

        setTimeout (->
          window.location = window.save_url + '/edit?step=' + resp.next_step
        ), 1000
      else
        CreateMeasuresSaveActions.showSuccessMessage()
        CreateMeasuresSaveActions.unlockButtonsAndHideSpinner()

  showSuccessMessage: ->
    $(".js-measure-form-success-message-container").removeClass('hidden')

  hideSuccessMessage: ->
    $(".js-measure-form-success-message-container").addClass('hidden')

  setSpinnerText: (message) ->
    $(".js-create-measures-continue-spinner .saving_message").text(message)

$ ->
  CreateMeasuresSaveActions.init()
