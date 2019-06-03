window.MainMenuInteractions =

  init: () ->
    MainMenuInteractions.deleteWorkbasketConfirmationPopupInit();
    MainMenuInteractions.withdrawWorkbasketConfirmationPopupInit();
    MainMenuInteractions.handleConfirmationLink();
    MainMenuInteractions.closeConfirmationPopup();

  deleteWorkbasketConfirmationPopupInit: () ->
    $(document).on 'click', '.js-main-menu-show-delete-confirmation-link', ->
      target_url = $(this).data("target-url")
      confirm_link = $("#main-menu-delete_confirmation_popup .js-main-menu-confirm-action")
      confirm_link.attr('href', target_url)
      confirm_link.attr('data-method', 'delete')

      MainMenuInteractions.setSpinnerText("main-menu-delete_confirmation_popup", "Deletion")
      MainMenuInteractions.openModal('main-menu-delete_confirmation_popup')

      return false

  withdrawWorkbasketConfirmationPopupInit: () ->
    $(document).on 'click', '.js-main-menu-show-withdraw-confirmation-link', ->
      target_url = $(this).data("target-url")
      confirm_link = $("#main-menu-withdraw_confirmation_popup_" + $(this).data("target-modal") + " .js-main-menu-confirm-action")
      confirm_link.attr('href', target_url)
      confirm_link.attr('data-method', 'get')

      MainMenuInteractions.setSpinnerText("main-menu-withdraw_confirmation_popup_" + $(this).data("target-modal"), "Processing")
      MainMenuInteractions.openModal("main-menu-withdraw_confirmation_popup_" + $(this).data("target-modal"))

      return false

  handleConfirmationLink: () ->
    $(document).on 'click', '.js-main-menu-confirm-action', ->
      $(this).addClass('hidden')
      $(".js-workbasket-base-save-progress-spinner").removeClass('hidden')
      $(".js-main-menu-close-popup").addClass('disabled')

      return false

  closeConfirmationPopup: () ->
    $(document).on 'click', '.js-main-menu-close-popup', ->
      popup_id = $(this).data('popup-id')
      MainMenuInteractions.closePopup(popup_id)

      return false

  openModal: (popup_id) ->
    MicroModal.show(popup_id)
    return false

  closePopup: (popup_id) ->
    $.each $(".js-main-menu-confirm-action"), (index, element) ->
      confirm_link = $(element)
      confirm_link.attr('href', '')
      confirm_link.removeAttr('data-method')

    $(".js-main-menu-close-popup").removeClass('disabled')

    MicroModal.close(popup_id)
    return false

  setSpinnerText: (popup_id, message) ->
    $("#" + popup_id + " .saving_message").text(message)

  scheduleExportToCdsFormInit: () ->
    $('.date-picker').each ->
      field = $(this)
      currentValue = field.val()

      if currentValue == '' || currentValue == undefined
        currentValue = moment(new Date()).add(1,'days')
      else
        currentValue = moment(currentValue, 'DD/MM/YYYY');

      picker = new Pikaday(
        field: $(this)[0]
        format: 'DD/MM/YYYY'
        blurFieldOnSelect: true
        defaultDate: currentValue.toDate()
        setDefaultDate: true
        minDate: moment().toDate()
        onSelect: ->
          $(this).trigger 'change'
          return false
      )

    return false

  handleViewPageActionForExportToCds: (read_only_url) ->
    if $(".js-schedule-export-to-cds").length > 0
      window.location = read_only_url

$ ->
  MainMenuInteractions.init();
