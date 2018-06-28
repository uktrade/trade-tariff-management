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
      return false

$ ->
  BulkEditSaveActions.init()
