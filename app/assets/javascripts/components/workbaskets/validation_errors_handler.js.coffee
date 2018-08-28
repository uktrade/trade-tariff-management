window.WorkbasketBaseValidationErrorsHandler =

  handleErrorsResponse: (response, workbasket_form) ->
    WorkbasketBaseValidationErrorsHandler.hideCustomErrorsBlock()
    WorkbasketBaseSaveActions.hideSuccessMessage()

    if response.responseJSON.step == "main"
      WorkbasketBaseValidationErrorsHandler.setFormErrors(response, workbasket_form)
    else
      WorkbasketBaseValidationErrorsHandler.renderErrorsBlock(response, workbasket_form)

    WorkbasketBaseSaveActions.unlockButtonsAndHideSpinner()

  setFormErrors: (response, workbasket_form) ->
    errors_list = response.responseJSON.errors

    if errors_list['measure'] isnt undefined
      errors_list = errors_list['measure']

    $.each errors_list, (key, value) ->
      if value.constructor == Array
        value.forEach (innerError) ->
          if innerError.constructor == Array
            workbasket_form.errors.push innerError[0]
            setTimeout (->
              WorkbasketBaseValidationErrorsHandler.renderAffectedCommoditiesBlock innerError
            ), 1000
          else
            workbasket_form.errors.push innerError
      else
        workbasket_form.errors.push value

    return false

  renderErrorsBlock: (response, workbasket_form) ->
    WorkbasketBaseValidationErrorsHandler.showCustomErrorsBlock()

    grouped_errors = response.responseJSON.errors
    general_errors = grouped_errors['general']
    measure_errors = grouped_errors['measure']

    flattened_errors = []

    $.each grouped_errors, (group_key, errors_collection) ->
      group_block = $(".js-workbasket-custom-errors[data-errors-container='general']")
      group_block.removeClass('hidden')
      list_block = group_block.find("ul")
      $.each errors_collection, (key, value) ->
        list_block.append("<li><div class='workbasket-error-block with_left_margin'>" + value + "</div></li>")


    # if general_errors isnt undefined
    #   $.each general_errors, (key, value) ->
    #     group_block = $(".js-workbasket-custom-errors[data-errors-container='general']")
    #     group_block.removeClass('hidden')
    #     list_block = group_block.find("ul")
    #     list_block.append("<li><div class='workbasket-error-block with_left_margin'>" + value + "</div></li>")

    #   delete grouped_errors['general']

    # $.each grouped_errors, (group_key, errors_collection) ->
    #   group_block = $(".js-workbasket-custom-errors[data-errors-container='" + group_key + "']")
    #   group_block.removeClass('hidden')
    #   list_block = group_block.find("ul")

    #   $.each errors_collection, (key, value) ->
    #     value.forEach (error) ->
    #       result_html = WorkbasketBaseValidationErrorsHandler.customErrorHtml(error)
    #       list_block.append(result_html)

  customErrorHtml: (error) ->
    text = error[0]
    commodities_list = error[1]
    affected_codes_html = WorkbasketBaseValidationErrorsHandler.content(commodities_list)

    return "<li><div class='workbasket-error-block with_left_margin'>" +
           text + affected_codes_html + "</div></li>"

  renderAffectedCommoditiesBlock: (error_object) ->
    text = error_object[0]
    commodities_list = error_object[1]

    error_container = $(".workbasket-error-block[data-error-message='" + text + "']")
    affected_codes_html = WorkbasketBaseValidationErrorsHandler.content(commodities_list)

    error_container.html(text + affected_codes_html)

    return false

  content: (commodities_list) ->
    return "<a class='js-show_hide_affected_codes' href='#'>Show affected codes</a>" +
           "<div class='clearfix'></div><span class='js-affected_codes_list hidden'>" +
           commodities_list.join(", ") +
           "</span>"

  showCustomErrorsBlock: () ->
    $(".js-workbasket-errors-container.js-custom-errors-block").removeClass('hidden')

  hideCustomErrorsBlock: () ->
    $(".js-workbasket-errors-container.js-custom-errors-block").addClass('hidden')
    $(".js-workbasket-custom-errors").addClass('hidden')
    $(".js-workbasket-custom-errors ul").empty()
