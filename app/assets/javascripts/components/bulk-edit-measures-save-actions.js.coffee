window.BulkEditOfMeasuresSaveActions =

  sendSaveRequest: ->
    bottom_limit = (window.__sb_current_batch - 1) * window.__sb_per_page
    top_limit = bottom_limit + window.__sb_per_page
    final_batch = false

    if window.__sb_current_batch == window.__sb_total_pages
      top_limit = window.__sb_total_count
      final_batch = true

    measures_collection = JSON.parse(JSON.stringify(window.__sb_measures_collection))

    data = {
      final_batch: final_batch
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
        BulkEditOfMeasuresSaveActions.sendNextBatch()
      error: (response) ->
        BulkEditOfMeasuresSaveActions.handleErrors(response)
        BulkEditOfMeasuresSaveActions.sendNextBatch()

    return false

  sendNextBatch: () ->
    window.__sb_current_batch = window.__sb_current_batch + 1
    if window.__sb_current_batch <= window.__sb_total_pages

      setTimeout (->
        BulkEditOfMeasuresSaveActions.sendSaveRequest()
      ), 3000
    else
      BulkEditOfMeasuresSaveActions.toogleSaveSpinner()
      BulkEditOfMeasuresSaveActions.unlock_buttons()

      mode = window.__save_bulk_edit_of_measures_mode

      if mode == "save_progress"
        if $(".has-validation-errors").length > 0
          $(".js-bulk-edit-of-measures-save-progress-details").html("Some measures are having validation errors! <br /> Please review table cells with highighted with red.")

        MicroModal.show("modal-1530613431");

      else
        if $(".has-validation-errors").length > 0
          $(".js-bulk-edit-of-measures-submission-issues").html("Some measures are having validation errors! <br /> Please review table cells with highighted with red.")

          MicroModal.show("modal-1530613432");
        else
          MicroModal.show("modal-1530613433");

      window.__save_bulk_edit_of_measures_mode = null

    return false

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
        url: '/measures/bulks/' + window.__workbasket_id.toString() + '/validation_details.js'
        data: { measure_sid: measure_sid, type: type }
        type: 'GET'
        contentType: 'application/json'
        success: (response) ->
          console.log('-success-')
          console.dir(response)

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

  unlock_buttons: ->
    $(".js-bulk-edit-of-measures-save-progress").removeClass('disabled')
    $(".js-bulk-edit-of-measures-submit-for-cross-check").removeClass('disabled')
    $(".js-bulk-edit-of-measures-exit").removeClass('disabled')

  closeErrorDetailsPopup: ->
    $(document).on 'click', '.js-bulk-edit-of-measures-error-details-close-popup', ->
      MicroModal.close("modal-1530613430")
      $(".js-bulk-edit-of-measures-error-details").html("")

      return false

    $(document).on 'click', '.js-bulk-edit-of-measures-save-progress-close-popup', ->
      MicroModal.close("modal-1530613431")
      $(".js-bulk-edit-of-measures-error-details").html("")

      return false

    $(document).on 'click', '.js-bulk-edit-of-measures-submission-failed-close-popup', ->
      MicroModal.close("modal-1530613432")
      $(".js-bulk-edit-of-measures-error-details").html("")

      return false

    $(document).on 'click', '.js-bulk-edit-of-measures-submission-success-close-popup', ->
      MicroModal.close("modal-1530613433")
      $(".js-bulk-edit-of-measures-error-details").html("")

      return false

$ ->
  BulkEditOfMeasuresSaveActions.getValidationErrors()
  BulkEditOfMeasuresSaveActions.closeErrorDetailsPopup()

