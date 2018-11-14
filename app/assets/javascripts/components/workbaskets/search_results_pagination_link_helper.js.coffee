window.WorkbasketSearchResultsPaginationHelper =

  init: () ->
    $(document).on 'click', '.pagination-link', ->
      WorkbasketSubmitSpinnerSupport.showSpinnerAndLockSubmissionButtons($(this))
