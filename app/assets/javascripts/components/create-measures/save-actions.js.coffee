window.CreateMeasuresSaveActions =

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

    if mode == "save_progress"
      submit_link.addClass('disabled')
    else
      save_link.addClass('disabled')

    exit_link.addClass('disabled')

  unlockButtonsAndHideSpinner: ->
    $(".spinner_block").addClass('hidden')
    $(".js-create-measures-v2-submit-button, .js-create-measures-exit-button").removeClass('disabled')
                                                                              .removeClass('hidden')

