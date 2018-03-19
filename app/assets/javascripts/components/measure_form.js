//= require vue
//= require vue-resource

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

  Vue.component('custom-select', {
    props: [
      "url",
      "value",
      "options",
      "placeholder",
      "labelField",
      "valueField",
      "searchField",
      "codeField",
      "minLength"
    ],
    data: function() {
      return {
        condition: {}
      }
    },
    template: "#selectize-template",
    mounted: function () {
      var vm = this;

      var options = {
        create: false,
        placeholder: this.placeholder,
        valueField: this.valueField,
        labelField: this.labelField,
        onType: function(str) { str || this.$dropdown_content.removeHighlight(); },
        onChange: function(){ this.$dropdown_content.removeHighlight(); }
      };

      if (this.options) {
        options["options"] = this.options;
      }

      if (this.url && !this.minLength) {
        options["onInitialize"] = function() {
          var self = this;
          var fn = self.settings.load;
          self.load(function(callback) {
              fn.apply(self, ["", callback]);
          });
        }
      }

      if (this.url) {
        options["load"] = function(query, callback) {
          if (options.minLength && query.length < options.minLength) return callback();
          $.ajax({
            url: vm.url,
            data: {
              q: query
            },
            type: 'GET',
            error: function() {
              callback();
            },
            success: function(res) {
              callback(res);
            }
          });
        }
      }

      var codeField = this.codeField;

      if (codeField) {
        options["render"] = {
          option: function(data) {
            return "<span class='selection" + (data.disabled ? ' selection--strikethrough' : '') + "'><span class='option-prefix option-prefix--series'>" + data[codeField] + "</span> " + data[options.labelField] + "</span>";
          },
          item: function(data) {
            return "<div class='item'>" + data[codeField] + " - " + data[options.labelField] + "</div>";
          }
        };
      }

      $(this.$el).selectize(options).val(this.value).trigger('change').on('change', function () {
        vm.$emit('input', this.value)
      });
    },
    watch: {
      value: function (value) {
        $(this.$el)[0].selectize.setValue(value, false);
      },
      options: function (options) {
        $(this.$el)[0].selectize.clearOptions();
        $(this.$el)[0].selectize.addOption(options);
        $(this.$el)[0].selectize.refreshOptions(false);
      }
    },
    destroyed: function () {
      $(this.$el).off()[0].selectize.destroy();
    }
  });

  Vue.component('quota-period', {
    template: "#quota-period-template",
    props: ["quotaPeriod", "index"],
    data: function() {
      return {
        quotaOptions: [
          { value: "annual", label: "Annual" },
          { value: "bi_annual", label: "Bi-Annual" },
          { value: "quarterly", label: "Quarterly" },
          { value: "monthly", label: "Monthly" },
          { value: "custom", label: "Custom" }
        ]
      }
    },
    computed: {
      isAnnual: function() {
        return this.quotaPeriod.type === "annual";
      },
      isQuarterly: function() {
        return this.quotaPeriod.type === "quarterly";
      },
      isBiAnnual: function() {
        return this.quotaPeriod.type === "bi_annual";
      },
      isMonthly: function() {
        return this.quotaPeriod.type === "monthly";
      },
      isCustom: function() {
        return this.quotaPeriod.type === "custom";
      },
      isAnnualOrCustom: function() {
        return this.isCustom || this.isAnnual;
      },
      isFirst: function() {
        return this.index === 0;
      }
    }
  });

  Vue.component('date-select', {
    template: "#date-select-template",
    props: ["value", "minYear"],
    computed: {
      days: function() {
        var days = [];
        for (var i = 1; i <= 31; i++) {
          days.push({ value: i, label: i });
        }

        return days;
      },
      months: function() {
        return [
          { value: 0, label: "January" },
          { value: 1, label: "February" },
          { value: 2, label: "March" },
          { value: 3, label: "April" },
          { value: 4, label: "May" },
          { value: 5, label: "June" },
          { value: 6, label: "July" },
          { value: 7, label: "August" },
          { value: 8, label: "September" },
          { value: 9, label: "October" },
          { value: 10, label: "November" },
          { value: 11, label: "December" }
        ];
      },
      years: function() {
        var minYear = this.minYear || (new Date()).getFullYear();
        var years = [];

        for (var i = 0; i < 80; i++) {
          years.push({ value: minYear + i, label: minYear + i });
        }

        return years;
      }
    }
  });

  Vue.component('measure-condition', {
    template: "#condition-template",
    props: ["condition"],
    computed: {
      showAction: function() {
        var codes = ["A"];

        return true;

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      showMinimumPrice: function() {
        var codes = [];

        return true;

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      showReferencePrice: function() {
        var codes = [];

        return true;

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      certificateActionHint: function() {
        var codes = ["A", "B", "C", "E", "I", "H", "Q", "Z"];

        return true;

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      noCertificateActionHint: function() {
        var codes = ["D", "F", "G", "L", "M", "N", "R", "U", "V", "E"];

        return true;

        return codes.indexOf(this.condition.condition_code) > -1;
      }
    }
  });

  var app = new Vue({
    el: form,
    data: function() {
      return {
        measure: {
          conditions: [],
          quota_periods: []
        },
        id: null
      };
    },
    mounted: function() {
      if (this.measure.quota_periods.length === 0) {
        this.measure.quota_periods.push({
          type: null,
          amount: null,
          start_date: null,
          end_date: null,
          measurement_unit_id: null,
          measurement_unit_qualifier_id: null
        });
      }
    },
    methods: {
      addCondition: function() {
        this.measure.conditions.push({
          _destroy: null,
          id: null,
          action_id: null,
          certificate_type_id: null,
          certificate_id: null
        });
      },
      addQuotaPeriod: function() {
        this.measure.quota_periods.push({
          type: "custom",
          amount: null,
          start_date: null,
          end_date: null,
          measurement_unit_id: null,
          measurement_unit_qualifier_id: null
        });
      }
    },
    computed: {
      showAddMoreQuotaPeriods: function() {
        if (this.measure.quota_periods.length <= 0) {
          return false;
        }

        return this.measure.quota_periods[0].type === "custom";
      },
      atLeastOneCondition: function() {
        return this.measure.conditions.length > 0;
      },
      noCondition: function() {
        return this.measure.conditions.length === 0;
      }
    },
    watch: {
      showAddMoreQuotaPeriods: function() {
        if (!this.showAddMoreQuotaPeriods) {
          this.measure.quota_periods.splice(1, 200);
        }
      }
    }
  });

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
