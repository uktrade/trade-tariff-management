window.CreateMeasuresValidationErrorsHandler =

  render_affected_commodities_block: (error_object) ->
    text = error_object[0]
    commodities_list = error_object[1]

    error_container = $(".create-measures-error-block[data-error-message='" + text + "']")
    affected_codes_html = CreateMeasuresValidationErrorsHandler.content(commodities_list)

    error_container.html(text + affected_codes_html)

    return false

  content: (commodities_list) ->
    return "<a class='js-show_hide_affected_codes' href='#'>Affected codes</a>" +
           "<div class='clearfix'></div><span class='js-affected_codes_list hidden'>" +
           commodities_list.join(", ") +
           "</span>"
