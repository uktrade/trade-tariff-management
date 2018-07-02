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
      success: (result) ->
        BulkEditOfMeasuresSaveActions.sendNextBatch()
      error: (response) ->
        BulkEditOfMeasuresSaveActions.handleErrors(response)
        BulkEditOfMeasuresSaveActions.sendNextBatch()

    return false

  sendNextBatch: ->
    window.__sb_current_batch = window.__sb_current_batch + 1
    if window.__sb_current_batch <= window.__sb_total_pages

      setTimeout (->
        BulkEditOfMeasuresSaveActions.sendSaveRequest()
      ), 3000

    return false

  handleErrors: (response) ->
    errored_measures = response.responseJSON["measures_with_errors"]

    $.each errored_measures, (measure_sid, errored_columns) ->
      measure_parent_div = $("[data-measure-sid='" + measure_sid + "']")

      $.each errored_columns, (index, errored_field_name) ->
        $("." + errored_field_name + "-column").addClass('has-validation-errors')
