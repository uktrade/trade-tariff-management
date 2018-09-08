window.BulkEditOfMeasuresSaveActions =

  sendSaveRequest: (mode) ->
    bottom_limit = (window.__sb_current_batch - 1) * window.__sb_per_page
    top_limit = bottom_limit + window.__sb_per_page
    final_batch = false

    if window.__sb_current_batch == window.__sb_total_pages
      top_limit = window.__sb_total_count
      final_batch = true

    measures_collection = JSON.parse(JSON.stringify(window.__sb_measures_collection))

    data = {
      mode: mode,
      final_batch: final_batch,
      bulk_measures_collection: measures_collection.slice(bottom_limit, top_limit)
    }

    ops = 'page=' + window.__sb_current_batch + '&bottom_limit=' + bottom_limit + '&top_limit=' + top_limit

    $.ajax
      url: '/measures/bulks/' + window.__workbasket_id.toString() + '.json?' + ops
      data: JSON.stringify(data)
      type: 'PUT'
      processData: false
      contentType: 'application/json'
      success: (response) ->
        BulkEditOfMeasuresSaveActions.cleanUpErrorBlocks(response)
        BulkEditOfMeasuresSaveActions.sendNextBatch(mode, response)
      error: (response) ->
        BulkEditOfMeasuresSaveActions.handleErrors(response)
        BulkEditOfMeasuresSaveActions.sendNextBatch(mode, response)

    return false

  sendNextBatch: (mode, response) ->
    window.__sb_current_batch = window.__sb_current_batch + 1
    if window.__sb_current_batch <= window.__sb_total_pages

      setTimeout (->
        BulkEditOfMeasuresSaveActions.sendSaveRequest(mode)
      ), 3000
    else
      BulkEditOfMeasuresSaveActions.toogleSaveSpinner()
      BulkEditOfMeasuresSaveActions.unlockButtons()
      BulkEditOfMeasuresSaveActions.showSummaryPopup()

      if mode == "save_group_for_cross_check" && response.redirect_url isnt undefined
        setTimeout (->
          window.location = response.redirect_url
        ), 1000

    return false

  cleanUpErrorBlocks: (response) ->
    $.each response.collection_sids, (index, measure_sid) ->
      measure_parent_div = $("[data-measure-sid='" + measure_sid + "']")
      measure_parent_div.find(".table__column")
                        .removeClass('has-validation-errors')

  handleErrors: (response) ->
    errored_measures = response.responseJSON["measures_with_errors"]

    $.each errored_measures, (measure_sid, errored_columns) ->
      measure_parent_div = $("[data-measure-sid='" + measure_sid + "']")

      $.each errored_columns, (index, errored_field_name) ->
        measure_parent_div.find("." + errored_field_name + "-column")
                          .addClass('has-validation-errors')

  getValidationErrors: ->
    $(document).on 'click', '.has-validation-errors', ->
      measure_sid = $(this).closest(".table__row")
                           .attr("data-measure-sid")

      type = $(this).attr("class")
                    .replace("table__column", "")
                    .replace("has-validation-errors", "")

      $.ajax
        url: '/measures/bulks/' + window.__workbasket_id.toString() + '/bulk_items/validation_details.js'
        data: { measure_sid: measure_sid, type: type }
        type: 'GET'
        contentType: 'application/json'

      return false

  toogleSaveSpinner: ->
    mode = window.__save_bulk_edit_of_measures_mode
    BulkEditOfMeasuresSaveActions.disable_other_buttons()

    if mode == "save_progress"
      link = $(".js-bulk-edit-of-measures-save-progress")
      spinner = $(".js-bulk-edit-of-measures-save-progress-spinner")
    else
      link = $(".js-bulk-edit-of-measures-submit-for-cross-check")
      spinner = $(".js-bulk-edit-of-measures-submit-for-cross-check-spinner")

    if link.hasClass('hidden')
      spinner.addClass('hidden')
      link.addClass('secondary-button')
      link.removeClass('hidden')
    else
      link.removeClass('secondary-button')
      link.addClass('hidden')
      spinner.removeClass('hidden')

  disable_other_buttons: ->
    save_link = $(".js-bulk-edit-of-measures-save-progress")
    submit_link = $(".js-bulk-edit-of-measures-submit-for-cross-check")
    exit_link = $(".js-bulk-edit-of-measures-exit")

    mode = window.__save_bulk_edit_of_measures_mode

    if mode == "save_progress"
      submit_link.addClass('disabled')
    else
      save_link.addClass('disabled')

    exit_link.addClass('disabled')

  unlockButtons: ->
    $(".js-bulk-edit-of-measures-save-progress").removeClass('disabled')
    $(".js-bulk-edit-of-measures-submit-for-cross-check").removeClass('disabled')
    $(".js-bulk-edit-of-measures-exit").removeClass('disabled')

  showSummaryPopup: ->
    modal_id = "bem-save-progress-summary"
    content = "There are no conformance errors"

    if $(".has-validation-errors").length > 0
      content = "Some measures have conformance errors, please review table cells with highlighted in red"

    if window.__save_bulk_edit_of_measures_mode == "save_group_for_cross_check"
      if $(".has-validation-errors").length > 0
        modal_id = "bem-submit-summary-failed"
      else
        modal_id = "bem-submit-summary-success"
        content = "You have submitted your work for cross-check"

    content_container = $("#" + modal_id + " .js-bem-popup-data-container")
    content_container.html(content)
    MicroModal.show(modal_id)

    window.__save_bulk_edit_of_measures_mode = null

    return false

$ ->
  BulkEditOfMeasuresSaveActions.getValidationErrors()

