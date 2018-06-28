window.BulkEditSaveActions =

  init: ->
    BulkEditSaveActions.submitCrossCheck()
    BulkEditSaveActions.saveProgress()

  submitCrossCheck: ->
    $(document).on "click", ".js-bulk-edit-of-measures-submit-for-cross-check", ->
      console.log("submitCrossCheck --")
      return false

  saveProgress: ->
    $(document).on "click", ".js-bulk-edit-of-measures-save-progress", ->
      console.log("saveProgress --")
      BulkEditSaveActions.sendDataToServer()

      return false

  sendDataToServer: ->
    # NEED MEASURES HERE
    measures = window.__measures

    data = { measures: measures }
    url = '/measures/bulks/' + window.__workbasket_id.toString()

    $.ajax
      url: url
      type: 'PUT'
      data: data
      success: (result) ->
        return false

    return false

$ ->
  BulkEditSaveActions.init()
