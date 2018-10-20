#
# FIX ME:
# So this fix is temporary.
# Issue is that when you call:
#
# self.errors = [SET ANY VALUE HERE];
#
# when start_date and end_date datepicker inputs
# are refreshing to empty values.
#

window.DatepickerRangeMonkeyPatch =

  fix: (first_date, second_date) ->
    start_date = $('input[name=\'' + first_date + '\']').val()
    start_date_formatted = ''

    if start_date.length > 0
      start_date_formatted = moment(start_date, 'DD/MM/YYYY').format('YYYY-MM-DD')

    end_date = $('input[name=\'' + second_date + '\']').val()
    end_date_formatted = ''

    if end_date.length > 0
      end_date_formatted = moment(end_date, 'DD/MM/YYYY').format('YYYY-MM-DD')

    setTimeout (->
      if start_date_formatted.length > 0
        window.js_start_date_pikaday_instance.setDate start_date_formatted
      if end_date_formatted.length > 0
        window.js_end_date_pikaday_instance.setDate end_date_formatted
      return
    ), 200

    return false
