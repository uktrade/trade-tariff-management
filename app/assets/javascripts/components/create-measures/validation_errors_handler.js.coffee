window.CreateMeasuresValidationErrorsHandler =

  handleErrorsResponse: (response, measure_form) ->
    CreateMeasuresSaveActions.hideSuccessMessage()

    if response.responseJSON.step == "main"
      CreateMeasuresValidationErrorsHandler.setFormErrors(response, measure_form)
    else
      CreateMeasuresValidationErrorsHandler.renderErrorsBlock(response)

    CreateMeasuresSaveActions.unlockButtonsAndHideSpinner()

  setFormErrors: (response, measure_form) ->
    errors_list = response.responseJSON.errors

    if errors_list['measure'] isnt undefined
      errors_list = errors_list['measure']

    $.each errors_list, (key, value) ->
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

  renderErrorsBlock: (response) ->
    $(".js-measure-form-errors-container.js-custom-errors-block").removeClass('hidden')

    $.each response.responseJSON.errors, (group_key, errors_collection) ->
      group_block = $(".js-create-measures-custom-errors[data-errors-container='" + group_key + "']")
      group_block.removeClass('hidden')
      list_block = group_block.find("ul")

      $.each errors_collection, (key, value) ->
        value.forEach (innerError) ->
          text = innerError[0]
          commodities_list = innerError[1]
          affected_codes_html = CreateMeasuresValidationErrorsHandler.content(commodities_list)
          list_block.append("<li><div class=create-measures-error-block'>" + text + affected_codes_html + "</div></li>")

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
