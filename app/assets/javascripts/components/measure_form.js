//= require ./custom-select
//= require ./date-select

function debounce(func, wait, immediate) {
  var timeout;
  return function() {
    var context = this, args = arguments;
    var later = function() {
      timeout = null;
      if (!immediate) func.apply(context, args);
    };
    var callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) func.apply(context, args);
  };
};

$(document).ready(function() {

  var form = document.querySelector(".measure-form");

  if (!form) {
    return;
  }

  Vue.component("measure-origin", {
    template: "#measure-origin-template",
    props: [
      "placeholder",
      "kind",
      "origin"
    ],
    mounted: function() {
      var self = this;
      var radio = $(this.$el).find("input[type='radio']");

      radio.on("change", function() {
        $(".measure-form").trigger("origin:changed");
      });

      $(".measure-form").on("origin:changed", function() {
        self.origin.selected = radio.is(":checked");
      });
    },
    computed: {
      radioID: function() {
        return "measure-origin-" + this.kind;
      },
      notErgaOmnes: function() {
        return this.kind !== "erga_omnes";
      },
      optionsForSelect: function() {
        if (this.kind === "group") {
          return window.geographical_groups_except_erga_omnes;
        } else if (this.kind === "country") {
          return window.all_geographical_countries;
        }
      },
      showExclusions: function() {
        return this.kind !== "country" && !!this.origin.geographical_area_id;
      }
    },
    watch: {
      "origin.geographical_area_id": function(newVal) {
        this.origin.exclusions.splice(0, 999);

        if (newVal) {
          this.origin.selected = true;
          $(this.$el).find("input[type='radio']").prop("checked", true).trigger("change");
          this.origin.exclusions.slice(0, 999);
          this.addExclusion();
        }
      },
      "origin.selected": function(newVal, oldVal) {
        if (newVal) {
          if (this.kind === "erga_omnes") {
            this.origin.geographical_area_id = '1011';
            this.addExclusion();
          }
        } else {
          this.origin.geographical_area_id = null;
        }
      }
    },
    methods: {
      addExclusion: function() {
        this.origin.exclusions.push({
          geographical_area_id: null,
          options: window.geographical_areas_json[this.origin.geographical_area_id]
        });
      },
      removeExclusion: function(exclusion) {
        var index = this.origin.exclusions.indexOf(exclusion);

        if (index === -1) {
          return;
        }

        this.origin.exclusions.splice(index, 1);
      }
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

  var componentCommonFunctionality = {
    computed: {
      showDutyAmountOrPercentage: function() {
        var ids = ["01", "02", "04", "19", "20"];

        return ids.indexOf(this[this.thing].duty_expression_id) > -1;
      },
      showDutyAmountPercentage: function() {
        var ids = ["23"];

        return ids.indexOf(this[this.thing].duty_expression_id) > -1;
      },
      showDutyAmountNegativePercentage: function() {
        var ids = ["36"];

        return ids.indexOf(this[this.thing].duty_expression_id) > -1;
      },
      showDutyAmountNumber: function() {
        var ids = ["06", "07", "09", "11", "12", "13", "14", "21", "25", "27", "29", "31"];

        return ids.indexOf(this[this.thing].duty_expression_id) > -1;
      },
      showDutyAmountMinimum: function() {
        var ids = ["15"];

        return ids.indexOf(this[this.thing].duty_expression_id) > -1;
      },
      showDutyAmountMaximum: function() {
        var ids = ["17", "35"];

        return ids.indexOf(this[this.thing].duty_expression_id) > -1;
      },
      showDutyRefundAmount: function() {
        var ids = ["40", "41", "42", "43", "44"];

        return ids.indexOf(this[this.thing].duty_expression_id) > -1;
      },
      showMonetaryUnit: function() {
        return this.showDutyAmountOrPercentage ||
               this.showDutyAmountNumber ||
               this.showDutyAmountMinimum ||
               this.showDutyAmountMaximum ||
               this.showDutyRefundAmount;
      },
      showMeasurementUnit: function() {
        var ids = ["23", "36", "37"];

        return this[this.thing].duty_expression_id && ids.indexOf(this[this.thing].duty_expression_id) === -1;
      }
    }
  };

  Vue.component("measure-component", $.extend({}, {
    template: "#measure-component-template",
    props: ["measureComponent"],
    data: function() {
      return {
        thing: "measureComponent"
      };
    }
  }, componentCommonFunctionality));

  Vue.component("measure-condition-component", $.extend({}, {
    template: "#measure-condition-component-template",
    props: ["measureConditionComponent"],
    data: function() {
      return {
        thing: "measureConditionComponent"
      };
    }
  }, componentCommonFunctionality));

  Vue.component("foot-note", {
    template: "#footnote-template",
    props: ["footnote"],
    data: function() {
      return {
        suggestions: [],
        lastSuggestionUsed: null
      };
    },
    computed: {
      hasSuggestions: function() {
        return this.suggestions.length > 0;
      }
    },
    mounted: function() {
      this.fetchSuggestions = debounce(this.fetchSuggestions.bind(this), 100, false);
    },
    methods: {
      fetchSuggestions: function() {
        var self = this;
        var type_id = this.footnote.footnote_type_id;
        var description =  this.footnote.description.trim();

        this.suggestions.splice(0, 999);

        if (description.length < 1) {
          return;
        }

        $.ajax({
          url: "/footnotes",
          data: {
            footnote_type_id: type_id,
            description: description
          },
          success: function(data) {
            self.suggestions = data;
          }
        });
      },
      useSuggestion: function(suggestion) {
        this.lastSuggestionUsed  = suggestion;
        this.footnote.description = suggestion.description;
        this.suggestions.splice(0, 999);
      }
    },
    watch: {
      "footnote.description": function(newVal, oldVal) {
        if (this.lastSuggestionUsed && newVal === this.lastSuggestionUsed.description) {
          return;
        }

        this.fetchSuggestions();
      }
    }
  });

  Vue.component('measure-condition', {
    template: "#condition-template",
    props: ["condition"],
    computed: {
      showAction: function() {
        var codes = ["K", "P", "S", "W", "Y"];

        return this.condition.condition_code && codes.indexOf(this.condition.condition_code) === -1;
      },
      showConditionComponents: function() {
        var codes = ["01", "02", "03", "11", "12", "13", "15", "27", "34", "36"];

        return codes.indexOf(this.condition.action_code) > -1;
      },
      showMinimumPrice: function() {
        var codes = ["F", "G", "L", "N"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      showRatio: function() {
        var codes = ["R", "U"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      showEntryPrice: function() {
        var codes = ["V"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      showAmount: function() {
        var codes = ["E", "I", "M"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      certificateActionHint: function() {
        var codes = ["A", "B", "C", "E", "I", "H", "Q", "Z"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      noCertificateActionHint: function() {
        var codes = ["D", "F", "G", "L", "M", "N", "R", "U", "V"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      showCertificateType: function() {
        var codes = ["B", "C", "E", "I", "H", "Q", "Z", "V", "E"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      showCertificate: function() {
        var codes = ["A", "B", "C", "E", "I", "H", "Q", "Z", "V", "E"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      showAddMoreCertificates: function() {
        var codes = ["A", "Z"];

        return codes.indexOf(this.condition.condition_code) > -1;
      },
      canRemoveComponent: function() {
        return this.condition.measure_condition_components.length > 1;
      }
    },
    watch: {
      showAction: function() {
        if (!this.showAction) {
          this.condition.action_code = null;
          this.condition.measure_condition_components = [{
            duty_expression_id: null,
            amount: null,
            measurement_unit_code: null,
            measurement_unit_qualifier_code: null
          }];
        }
      },
      "condition.certificate_type_id": function() {
        this.certificate_id = null;
      },
      showCertificateType: function(newVal, oldVal) {
        if (oldVal === false && newVal === true) {
          this.certificate_id = null;
        }
      }
    },
    methods: {
      addMeasureConditionComponent: function() {
        this.condition.measure_condition_components.push({
          duty_expression_id: null,
          amount: null,
          measurement_unit_code: null,
          measurement_unit_qualifier_code: null
        });
      },
      removeMeasureConditionComponent: function(measureConditionComponent) {
        var idx = this.condition.measure_condition_components.indexOf(measureConditionComponent);

        if (idx === -1) {
          return;
        }

        this.condition.measure_condition_components.splice(idx, 1);
      }
    }
  });

  var app = new Vue({
    el: form,
    data: function() {
      var data = {
        goods_nomenclature_code: "",
        additional_code: null,
        goods_nomenclature_code_description: "",
        additional_code_description: "",
        quota_statuses: [
          { value: "open", label: "Open" },
          { value: "exhausted", label: "Exhausted" },
          { value: "critical", label: "Critical" },
          { value: "unblocked", label: "Unblocked" },
          { value: "unsuspended", label: "Unsuspended" },
          { value: "reopened", label: "Reopened" }
        ],
        origins: {
          country: {
            geographical_area_id: null,
            exclusions: [],
            selected: false
          },
          group: {
            geographical_area_id: null,
            exclusions: [],
            selected: false
          },
          erga_omnes: {
            geographical_area_id: null,
            exclusions: [],
            selected: false
          }
        },
        errors: []
      };

      if (window.__measure) {
        this.parseMeasure(window.__measure);
      } else {
        data.measure = {
          operation_date: null,
          regulation_id: null,
          measure_type_series_id: null,
          measure_type_id: null,
          quota_ordernumber: null,
          quota_status: "open",
          quota_criticality_threshold: null,
          quota_description: null,
          geographical_area_id: null,
          excluded_geographical_areas: [],
          conditions: [],
          quota_periods: [],
          measure_components: [],
          footnotes: [],
          existing_quota: null
        };
      }

      return data;
    },
    mounted: function() {
      var self = this;

      if (this.measure.quota_periods.length === 0) {
        this.addQuotaPeriod(true);
      }

      if (this.measure.conditions.length === 0) {
        this.addCondition();
      }

      if (this.measure.footnotes.length === 0) {
        this.measure.footnotes.push({
          footnote_type_id: null,
          description: null
        });
      }

      if (this.measure.measure_components.length === 0) {
        this.measure.measure_components.push({
          duty_expression_id: null,
          amount: null,
          measurement_unit_code: null,
          measurement_unit_qualifier_code: null
        });
      }

      this.fetchNomenclatureCode("/goods_nomenclatures", 10, "goods_nomenclature_code", "goods_nomenclature_code_description");

      $("#measure_form_measure_type_series_id").on("change", function() {
        self.measure.measure_type_series_id = $("#measure_form_measure_type_series_id").val();
      });

      $("#measure_form_measure_type_id").on("change", function() {
        self.measure.measure_type_id = $("#measure_form_measure_type_id").val();
      });

      $(".measure-form").on("submit", function(e) {
        e.preventDefault();
        e.stopPropagation();

        var button = $("input[type='submit']");
        button.attr("data-text", button.val());
        button.val("Saving...");
        button.prop("disabled", true);

        self.errors = [];

        $.ajax({
          url: "/measures",
          type: "POST",
          data: {
            measure: self.preparePayload()
          },
          success: function(response) {
            $(".js-measure-form-errors-container").empty().addClass("hidden");
            window.location = "/measures?code=" + response.goods_nomenclature_item_id;
          },
          error: function(response) {
            //TODO: handle errors
            button.val(button.attr("data-text"));
            button.prop("disabled", false);

            $.each( response.responseJSON.errors, function( key, value ) {
              if (value.constructor === Array) {
                value.forEach(function(innerError) {
                  self.errors.push(innerError);
                });
              } else {
                self.errors.push(value);
              }
            });
          }
        });
      });

      $(".measure-form").on("geoarea:changed", function(e, id) {
        self.measure.geographical_area_id = id;
      });

      $(".measure-form").on("exclusions:changed", function(e, ids) {
        self.measure.excluded_geographical_areas = ids;
      });
    },
    methods: {
      parseMeasure: function(raw) {
        var actual = {
          measure_id: raw.measure_id,
          regulation_id: raw.regulation_id,
          measure_type_series_id: raw.measure_type_series_id,
          measure_type_id: raw.measure_type_id,
          quota_ordernumber: raw.quota_ordernumber,
          quota_status: raw.quota_status,
          quota_criticality_threshold: raw.quota_criticality_threshold,
          quota_description: raw.quota_description,
          geographical_area_id: raw.geographical_area_id,
          excluded_geographical_areas: raw.excluded_geographical_areas,
          conditions: [],
          quota_periods: [],
          measure_components: [],
          footnotes: raw.footnotes
        };


        return actual;
      },
      addCondition: function() {
        this.measure.conditions.push({
          id: null,
          action_code: null,
          certificate_type_id: null,
          certificate_id: null,
          measure_condition_components: [
            {
              duty_expression_id: null,
              amount: null,
              measurement_unit_code: null,
              measurement_unit_qualifier_code: null
            }
          ]
        });
      },
      addQuotaPeriod: function(first) {
        this.measure.quota_periods.push({
          type: first === true ? null : "custom",
          monthly: {
            amount1: null,
            amount2: null,
            amount3: null,
            amount4: null,
            amount5: null,
            amount6: null,
            amount7: null,
            amount8: null,
            amount9: null,
            amount10: null,
            amount11: null,
            amount12: null,
          },
          quarterly: {
            amount1: null,
            amount2: null,
            amount3: null,
            amount4: null
          },
          bi_annual: {
            amount1: null,
            amount2: null
          },
          annual: {
            amount1: null
          },
          custom: {
            amount1: null
          },
          start_date: null,
          end_date: null,
          measurement_unit_id: null,
          measurement_unit_qualifier_id: null
        });
      },
      addMeasureComponent: function() {
        this.measure.measure_components.push({
          duty_expression_id: null,
          amount: null,
          measurement_unit_code: null,
          measurement_unit_qualifier_code: null
        });
      },
      addFootnote: function() {
        this.measure.footnotes.push({
          footnote_type_id: null,
          description: null
        });
      },
      fetchNomenclatureCode: function(url, length, code, description, type, description_field) {
        var self = this;
        if (this[code].trim().length === length) {
          $.ajax({
            url: url,
            data: {
              q: this[code].trim()
            },
            success: function(data) {

              if (type === "json") {
                if (data.length > 0) {
                  self[description] = data[0][description_field];
                  self.measure[code] = self[code].trim();
                } else {
                  self[description] = "";
                  self.measure[code] = null;
                }
              } else {
                self[description] = data;
                self.measure[code] = self[code].trim();
              }

            },
            error: function() {
              self[description] = "";
              self.measure[code] = null;
            }
          });
        } else {
          self[description] = "";
          self.measure[code] = null;
        }
      },
      preparePayload: function() {
        var payload = {
          operation_date: this.measure.operation_date,

          start_date: this.measure.validity_start_date,
          end_date: this.measure.validity_end_date,
          regulation_id: this.measure.regulation_id,
          measure_type_series_id: this.measure.measure_type_series_id,
          measure_type_id: this.measure.measure_type_id,
          goods_nomenclature_code: this.measure.goods_nomenclature_code,
          additional_code: this.measure.additional_code,
          additional_code_type_id: this.measure.additional_code_type_id,
          goods_nomenclature_code_description: this.measure.goods_nomenclature_code_description,
          additional_code_description: this.measure.additional_code_description,

          measure_components: this.measure.measure_components,
          footnotes: this.measure.footnotes,
          conditions: this.measure.conditions,

          existing_quota: this.measure.existing_quota === "existing",
          quota_status: this.measure.quota_status,
          quota_ordernumber: this.measure.quota_ordernumber,
          quota_criticality_threshold: this.measure.quota_criticality_threshold,
          quota_description: this.measure.quota_description
        };

        if (this.origins.country.selected) {
          payload.geographical_area_id = this.origins.country.geographical_area_id;
          payload.excluded_geographical_areas = this.origins.country.exclusions.map(function(e) {
            return e.geographical_area_id;
          });
        } else if (this.origins.group.selected) {
          payload.geographical_area_id = this.origins.group.geographical_area_id;
          payload.excluded_geographical_areas = this.origins.group.exclusions.map(function(e) {
            return e.geographical_area_id;
          });
        } else if (this.origins.erga_omnes.selected) {
          payload.geographical_area_id = this.origins.erga_omnes.geographical_area_id;
          payload.excluded_geographical_areas = this.origins.erga_omnes.exclusions.map(function(e) {
            return e.geographical_area_id;
          });
        }

        if (this.measure.quota_periods.length > 0 && this.measure.quota_periods[0].type) {
          var periodPayload = {};

          switch (this.measure.quota_periods[0].type) {
            case "custom":
              var t = this.measure.quota_periods[0].type;

              periodPayload[t] = this.measure.quota_periods.map(function(period) {
                return {
                  amount1: period.custom.amount1,
                  start_date: period.start_date,
                  end_date: period.end_date,
                  measurement_unit_code: period.measurement_unit_code,
                  measurement_unit_qualifier_code: period.measurement_unit_qualifier_code
                };
              });

              break;
            default:
              var t = this.measure.quota_periods[0].type;

              periodPayload[t] = this.measure.quota_periods[0][t];
              periodPayload[t].start_date = this.measure.quota_periods[0].start_date;
              periodPayload[t].end_date = this.measure.quota_periods[0].end_date;
              periodPayload[t].measurement_unit_code = this.measure.quota_periods[0].measurement_unit_code;
              periodPayload[t].measurement_unit_qualifier_code = this.measure.quota_periods[0].measurement_unit_qualifier_code;

              break;
          }

          payload.quota_periods = periodPayload;
        } else {
          payload.quota_periods = {};
        }

        return payload;
      },
      removeQuotaPeriod: function(quotaPeriod) {
        var index = this.measure.quota_periods.indexOf(quotaPeriod);

        if (index === -1) {
          return;
        }

        this.measure.quota_periods.splice(index, 1);
      },
      removeFootnote: function(footnote) {
        var index = this.measure.footnotes.indexOf(footnote);

        if (index === -1) {
          return;
        }

        this.measure.footnotes.splice(index, 1);
      },
      removeMeasureComponent: function(measureComponent) {
        var index = this.measure.measure_components.indexOf(measureComponent);

        if (index === -1) {
          return;
        }

        this.measure.measure_components.splice(index, 1);
      },
      removeCondition: function(condition) {
        var index = this.measure.conditions.indexOf(condition);

        if (index === -1) {
          return;
        }

        this.measure.conditions.splice(index, 1);
      }
    },
    computed: {
      showAddMoreQuotaPeriods: function() {
        if (this.measure.quota_periods.length <= 0) {
          return false;
        }

        return this.measure.quota_periods[0].type === "custom";
      },
      showDuties: function() {
        var series = ["A", "B", "M", "N"];

        return this.measure.measure_type_series_id && series.indexOf(this.measure.measure_type_series_id) === -1;
      },
      showQuota: function() {
        if (!this.measure.measure_type_series_id || !this.measure.measure_type_id ) {
          return false;
        }

        if (this.measure.measure_type_series_id == "N") {
          return true;
        }

        var ids = ["122", "123", "143", "144", "146", "147", "907"];

        if (this.measure.measure_type_series_id == "C" && ids.indexOf(this.measure.measure_type_id) > -1) {
          return true;
        }

        return false;
      },
      showStandardImportValue: function() {
        return this.measure.measure_type_id === "490";
      },
      showReferencePrice: function() {
        return this.measure.measure_type_id === "489";
      },
      showUnitPrice: function() {
        return this.measure.measure_type_id === "488";
      },
      atLeastOneCondition: function() {
        return this.measure.conditions.length > 0;
      },
      noCondition: function() {
        return this.measure.conditions.length === 0;
      },
      hasErrors: function() {
        return this.errors.length > 0;
      },
      canRemoveQuota: function() {
        return this.measure.quota_periods.length > 1;
      },
      canRemoveFootnote: function() {
        return this.measure.footnotes.length > 1;
      },
      canRemoveCondition: function() {
        return this.measure.conditions.length > 1;
      },
      canRemoveMeasureComponent: function() {
        return this.measure.measure_components.length > 1;
      },
      creatingNewQuota: function() {
        return this.measure.existing_quota === "new";
      },
      usingExistingQuota: function() {
        return this.measure.existing_quota === "existing";
      }
    },
    watch: {
      showAddMoreQuotaPeriods: function() {
        if (!this.showAddMoreQuotaPeriods) {
          this.measure.quota_periods.splice(1, 200);
        }
      },
      goods_nomenclature_code: function() {
        this.fetchNomenclatureCode("/goods_nomenclatures", 10, "goods_nomenclature_code", "goods_nomenclature_code_description");
      },
      "measure.validity_start_date": function() {
        window.measure_start_date = this.measure.validity_start_date;

        $(".measure-form").trigger("dates:changed", [this.measure.validity_start_date, this.measure.validity_end_date]);
      },
      "measure.validity_end_date": function() {
        window.measure_end_date = this.measure.validity_end_date;

        $(".measure-form").trigger("dates:changed", [this.measure.validity_start_date, this.measure.validity_end_date]);
      },
      "measure.additional_code_type_id": function(newVal, oldVal) {
        if (oldVal && !newVal) {
          this.measure.additional_code = null;
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
    searchField: ["measure_type_series_id", "description"],
    allowClear: true,
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
    searchField: ["measure_type_id", "description"],
    allowClear: true,
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

    var newOptions = window.measure_types_json.filter(function(d) {
      return !v || (v && d.measure_type_series_id == v);
    });

    measureType[0].selectize.addOption(newOptions);
    measureType[0].selectize.refreshOptions(false);
  });

  $(".measure-form").on("dates:changed", function(event, start_date, end_date) {
    $("#measure_form_measure_type_id").val("");
    $("#measure_form_measure_type_id").trigger("change");

    $("#measure_form_measure_type_series_id").val("");
    $("#measure_form_measure_type_series_id").trigger("change");

    $.ajax({
      url: "/measure_types",
      data: {
        start_date: start_date,
        end_date: end_date
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
        start_date: start_date,
        end_date: end_date
      },
      success: function(data) {
        window.measure_types_series_json = data;
        measureTypeSeries[0].selectize.clearOptions();
        measureTypeSeries[0].selectize.addOption(data);
        measureTypeSeries[0].selectize.refreshOptions(false);
      }
    });
  });
});
