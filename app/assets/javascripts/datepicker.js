$(document).ready(function(){
  $('[data-behaviour~=datepicker]').each(function() {
    var picker = new Pikaday({
      field: $(this)[0],
      format: "DD/MM/YYYY",
      blurFieldOnSelect: true
    });

    if (input.value === "") {
      // we set current date only if we don't have
      // already a value
      picker.setDefaultDate(new Date());
    }
  });

  $('.datepicker').each(function() {
    var field = $(this);

    new Pikaday({
      field: $(this)[0],
      format: "DD/MM/YYYY",
      blurFieldOnSelect: true,
      onSelect: function() {
        $(this).trigger("change");
      }
    });
  });

  var start_date = $(".start-date");
  var end_date = $(".end-date");

  if (start_date.length > 0 && end_date.length > 0) {
    var start = new Pikaday({
      field: start_date[0],
      format: "DD/MM/YYYY",
      blurFieldOnSelect: true,
      onSelect: function(value) {
        start_date.trigger("change");

        end.setMinDate(this.getMoment().toDate());
        start.setStartRange(this.getMoment().toDate());
        end.setStartRange(this.getMoment().toDate());
      }
    });

    var end = new Pikaday({
      field: end_date[0],
      format: "DD/MM/YYYY",
      blurFieldOnSelect: true,
      onSelect: function(value) {
        end_date.trigger("change");

        start.setMaxDate(this.getMoment().toDate());
        start.setEndRange(this.getMoment().toDate());
        end.setEndRange(this.getMoment().toDate());

      }
    });

    start_date.on("change", function() {
      if (!$(this).val()) {
        end.setStartRange(null);
        start.setStartRange(null);
        start.setMinDate(moment().subtract(100, "years").toDate());
      }
    });

    end_date.on("change", function() {
      if (!$(this).val()) {
        end.setEndRange(null);
        start.setEndRange(null);
        start.setMaxDate(moment().add(300, "years").toDate());
      }
    });

    window.js_start_date_pikaday_instance = start;
    window.js_end_date_pikaday_instance = end;
  }
});
