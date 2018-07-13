window.CreateMeasuresMainStepAdvancedActions =

  init: ->
    CreateMeasuresMainStepAdvancedActions.checkCodeShowHideFunction()

  checkCodeShowHideFunction: ->
    $(document).on 'click', '.js-create-measures-check-code-description', ->
      parent = $(this).closest(".js-create-measures-check-code-parent-container")

      container = parent.find(".js-create-measures-check-code-container")

      if container.hasClass("hidden")
        container.removeClass("hidden")
      else
        container.addClass("hidden")

      return false

$ ->
  CreateMeasuresMainStepAdvancedActions.init()

