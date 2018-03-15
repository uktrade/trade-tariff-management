function Origin(el) {
  this.choice = el;
  this.select = el.find("select");
  this.radio = el.find("input[type='radio']");
  this.target = el.next();

  this.onSelect = undefined;
  this.onExclusionsUpdate = undefined;

  this.deselect = this.deselect.bind(this);

  this.geographical_area_id = null;
  this.selected = [];

  this.init();
  this.bindEvents();
}

Origin.prototype.init = function () {
  this.select.selectize({
    placeholder: this.select.data("placeholder"),
    create: false,
    valueField: 'geographical_area_id',
    labelField: 'description',
    searchField: ["description", "text"],
    onType: function(str) { str || this.$dropdown_content.removeHighlight(); },
    onChange: function(){ this.$dropdown_content.removeHighlight(); }
  });
};

Origin.prototype.bindEvents = function () {
  var self = this;

  this.select.on("change", function() {
    var val = self.select.val();

    if (val)  {
      self.radio.prop("checked", true).trigger("change");
      self.geographical_area_id = val;

      if (window.geographical_areas_json[self.geographical_area_id].length > 0) {
        self.target.find(".exclusions-target").empty();
        self.addExclusion();
        self.openExclusions();
      }

      if (self.onSelect !== undefined) {
        self.onSelect(self);
      }
    }
  });

  this.radio.on("change", function() {
    var checked = self.radio[0].checked;

    if (checked) {
      if (self.select.length <= 0) {
        self.geographical_area_id = '1011';

        if (window.geographical_areas_json[self.geographical_area_id].length > 0) {
          self.target.find(".exclusions-target").empty();
          self.addExclusion();
          self.openExclusions();
        }
      }

      if (self.onSelect !== undefined) {
        self.onSelect(self);
      }
    }
  });

  this.target.on("click", ".js-add-country-exclusion", function(e) {
    e.preventDefault();
    e.stopPropagation();

    self.addExclusion();
  });

  this.target.on("change", "select", function() {
    self.updateSelectedValues();
  })
};

Origin.prototype.openExclusions = function () {
  this.target.removeClass("js-hidden");
};

Origin.prototype.closeExclusions = function () {
  this.target.addClass("js-hidden");
  this.target.find(".exclusions-target").empty();
};

Origin.prototype.deselect = function () {
  this.closeExclusions();

  if (this.select.length > 0) {
    this.select[0].selectize.clear(true);
  }

  this.geographical_area_id = null;
  this.selected = [];
};

Origin.prototype.addExclusion = function () {
  var html = $("<p><select class='exclusion-select'></select></p>");

  html.find("select").selectize({
    options: window.geographical_areas_json[this.geographical_area_id],
    placeholder: "― start typing ―",
    create: false,
    valueField: 'geographical_area_id',
    labelField: 'description',
    searchField: ["geographical_area_id", "description", "text"],
    onType: function(str) { str || this.$dropdown_content.removeHighlight(); },
    onChange: function(){ this.$dropdown_content.removeHighlight(); }
  });

  var selectize = html.find("select")[0].selectize;
  var checkMinLength = function() {
    if (selectize.$control_input.val().length < 2) {
      selectize.close();
    }
  };

  selectize.on('dropdown_open', checkMinLength);
  selectize.$control_input.on('input', checkMinLength);

  this.target.find(".exclusions-target").append(html);
};

Origin.prototype.updateSelectedValues = function () {
  var values = [];

  this.target.find("select").each(function() {
    var val = $(this).val();

    if (val) {
      values.push(val);
    }
  });

  this.selected = values;

  if (this.onExclusionsUpdate !== undefined) {
    this.onExclusionsUpdate(values);
  }
}

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
    onType: function(str) { str || this.$dropdown_content.removeHighlight(); },
    onChange: function(){ this.$dropdown_content.removeHighlight(); },
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
    onType: function(str) { str || this.$dropdown_content.removeHighlight(); },
    onChange: function(){ this.$dropdown_content.removeHighlight(); },
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
  });

  var origins = [];

  var handleOnSelect = function(obj) {
    origins.forEach(function(origin) {
      if (origin !== obj) {
        origin.deselect();
      }
    });

    $("#measure_form_excluded_geographical_areas").val([]);
  };

  var handleUpdate = function(ids) {
    $("#measure_form_excluded_geographical_areas").val(ids);
  };

  $(".origins-region .multiple-choice").each(function() {
    var origin = new Origin($(this));
    origin.onSelect = handleOnSelect;
    origin.onExclusionsUpdate = handleUpdate;

    origins.push(origin);
  });
});
