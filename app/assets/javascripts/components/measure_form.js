$(document).ready(function() {

  var form = document.querySelector(".measure-form");

  if (!form) {
    return;
  }

  var findMeasureTypeById = function(id) {
    for (var k in window.measure_types_json) {
      if (!window.measure_types_json.hasOwnProperty(k)) {
        continue;
      }

      for (var i = 0; i < window.measure_types_json[k].length; i++) {
        var type = window.measure_types_json[k][i];

        if (type.measure_type_id == id) {
          return type;
        }
      }
    }

    return null;
  };

  var findMeasureTypeSeriesById = function(id) {
    for (var i = 0; i < window.measure_types_series_json.length; i++) {
      var type = window.measure_types_series_json[i];

      if (type.measure_type_series_id == id) {
        return type;
      }
    }

    return null;
  }

  var measureTypeSeries = $("#measure_form_measure_type_series_id").selectize({
    create: false,
    placeholder: "― optionally filter by measure series ―",
    valueField: 'measure_type_series_id',
    labelField: 'description',
    render: {
      option: function(data) {
        return "<span class='selection" + (data.disabled ? ' selection--strikethrough' : '') + "'><span class='option-prefix option-prefix--series'>" + data.measure_type_series_id + "</span> " + data.description + "</span>";
      },
      item: function(data) {
        return "<div class='item'>" + data.measure_type_series_id + " - " + data.description + "</div>";
      }
    }
  });

  var measureType = $("#measure_form_measure_type_id").selectize({
    placeholder: "― select measure type ―",
    create: false,
    valueField: 'measure_type_id',
    labelField: 'description',
    render: {
      option: function(data) {
        return "<span class='selection" + (data.disabled ? ' selection--strikethrough' : '') + "'><span class='option-prefix option-prefix--type'>" + data.measure_type_id + "</span> " + data.description + "</span>";
      },
      item: function(data) {
        return "<div class='item'>" + data.measure_type_id + " - " + data.description + "</div>";
      }
    }
  });

  $("#measure_form_measure_type_series_id").on("change", function() {
    var v = $("#measure_form_measure_type_series_id").val();

    $("#measure_form_measure_type_id").val("");
    measureType[0].selectize.clearOptions();
    measureType[0].selectize.addOption(window.measure_types_json.filter(function(d) {
      return !v || (v && d.measure_type_series_id == v);
    }));
    measureType[0].selectize.refreshOptions(false);
  });

  $("#measure_form_validity_start_date").on("change", function() {
    var start_date = $("#measure_form_validity_start_date").val();

    $("#measure_form_measure_type_id").val("");
    $("#measure_form_measure_type_id").trigger("change");

    $("#measure_form_measure_type_series_id").val("");
    $("#measure_form_measure_type_series_id").trigger("change");

    $.ajax({
      url: "/measure_types",
      data: {
        as_of: start_date
      },
      success: function(data) {
        window.measure_types_json = data;
        measureType[0].selectize.clearOptions();
        measureType[0].selectize.addOption(data);
        measureType[0].selectize.refreshOptions(false);
      }
    });

    $.ajax({
      url: "/measure_type_series",
      data: {
        as_of: start_date
      },
      success: function(data) {
        window.measure_types_series_json = data;
        measureTypeSeries[0].selectize.clearOptions();
        measureTypeSeries[0].selectize.addOption(data);
        measureTypeSeries[0].selectize.refreshOptions(false);
      }
    });
  })
});
