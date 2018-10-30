window.ViewGeoAreaWorkbasketFunctions =

  init: () ->
    $(document).on 'click', '.js-workbasket-geographical-area-show-hide-descriptions', ->
      link = $(this)
      other_descriptions_block = $('.js-view-geographical-area-other-descriptions-block')

      if other_descriptions_block.hasClass('hidden')
        link.text("Hide other descriptions for this geographical area")
        other_descriptions_block.removeClass('hidden')
      else
        link.text("Show other descriptions for this geographical area")
        other_descriptions_block.addClass('hidden')

      return false;

$ ->
  ViewGeoAreaWorkbasketFunctions.init();
