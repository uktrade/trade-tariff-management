$(document).ready(function(){
  $('[data-behaviour~=datepicker]').each(function() {
    var picker = new Pikaday({
      field: $(this)[0],
      format: "YYYY/MM/DD",
      blurFieldOnSelect: true
    });

    if (input.value === "") {
      // we set current date only if we don't have
      // already a value
      picker.setDefaultDate(new Date());
    }
  });

  $('.datepicker').each(function() {
    new Pikaday({
      field: $(this)[0],
      format: "YYYY/MM/DD",
      blurFieldOnSelect: true
    });
  });
});
