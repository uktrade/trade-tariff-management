window.CreateMeasuresMainStepAdvancedActions =

  init: ->
    CreateMeasuresMainStepAdvancedActions.checkCommodityCodeShowHideFunction()

  checkCommodityCodeShowHideFunction: ->
    $(document).on 'click', '.js-create-measures-check-commodity-code-description', ->
      console.log('- CODE -')

      container = $(".js-create-measures-check-commodity-code-container")

      if container.hasClass("hidden")
        container.removeClass("hidden")
      else
        container.addClass("hidden")

      return false

$ ->
  CreateMeasuresMainStepAdvancedActions.init()

