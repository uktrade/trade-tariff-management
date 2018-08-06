window.WorkbasketCreateQuota =

  init: () ->
    $(document).on "change", "input[name='quota_is_licensed']", ->
      licence_block = $(".js-workbasket-create-quota-licence-block")

      if $("input[name='quota_is_licensed']:checked").val() isnt undefined
        licence_block.removeClass("hidden")
      else
        licence_block.addClass("hidden")

$ ->
  WorkbasketCreateQuota.init()
