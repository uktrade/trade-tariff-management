window.WorkbasketBaseCommon =

  init: ->
    WorkbasketBaseCommon.showHideAffectedCommoditiesBlock()
    WorkbasketBaseCommon.checkCodeShowHideFunction()

  showHideAffectedCommoditiesBlock: () ->
    $(document).on 'click', '.js-show_hide_affected_codes', ->
      parent = $(this).closest(".workbasket-error-block")

      container = parent.find(".js-affected_codes_list")

      if container.hasClass("hidden")
        container.removeClass("hidden")
        $(this).text('Hide affected codes')
      else
        container.addClass("hidden")
        $(this).text('Show affected codes')

      return false

  checkCodeShowHideFunction: ->
    $(document).on 'click', '.js-workbasket-check-code-description', ->
      parent = $(this).closest(".js-workbasket-check-code-parent-container")

      container = parent.find(".js-workbasket-check-code-container")

      if container.hasClass("hidden")
        container.removeClass("hidden")
      else
        container.addClass("hidden")

      return false

$ ->
  WorkbasketBaseCommon.init()
