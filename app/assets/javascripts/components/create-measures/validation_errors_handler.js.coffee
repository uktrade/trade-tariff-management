window.CreateMeasuresValidationErrorsHandler =

  handleErrorsResponse: (response, measure_form) ->
    CreateMeasuresSaveActions.hideSuccessMessage()
    CreateMeasuresValidationErrorsHandler.setFormErrors(response, measure_form)
    CreateMeasuresSaveActions.unlockButtonsAndHideSpinner()

  setFormErrors: (response, measure_form) ->
    $.each response.responseJSON.errors, (key, value) ->
      if value.constructor == Array
        value.forEach (innerError) ->
          if innerError.constructor == Array
            measure_form.errors.push innerError[0]
            setTimeout (->
              CreateMeasuresValidationErrorsHandler.renderAffectedCommoditiesBlock innerError
            ), 1000
          else
            measure_form.errors.push innerError
      else
        measure_form.errors.push value

    return false

  initShowHideAffectedCommoditiesBlock: () ->
    $(document).on 'click', '.js-show_hide_affected_codes', ->
      parent = $(this).closest(".create-measures-error-block")

      container = parent.find(".js-affected_codes_list")

      if container.hasClass("hidden")
        container.removeClass("hidden")
        $(this).text('Hide affected codes')
      else
        container.addClass("hidden")
        $(this).text('Show affected codes')

      return false

  renderAffectedCommoditiesBlock: (error_object) ->
    text = error_object[0]
    commodities_list = error_object[1]

    error_container = $(".create-measures-error-block[data-error-message='" + text + "']")
    affected_codes_html = CreateMeasuresValidationErrorsHandler.content(commodities_list)

    error_container.html(text + affected_codes_html)

    return false

  content: (commodities_list) ->
    return "<a class='js-show_hide_affected_codes' href='#'>Show affected codes</a>" +
           "<div class='clearfix'></div><span class='js-affected_codes_list hidden'>" +
           commodities_list.join(", ") +
           "</span>"

$ ->
  CreateMeasuresValidationErrorsHandler.initShowHideAffectedCommoditiesBlock()
