//= require ./conditions-parser

$(document).ready(function() {

  var form = document.querySelector(".quota-form");

  if (!form) {
    return;
  }

  var app = new Vue({
    el: form,
    data: function() {
      var self = this;

      var data = {
        savedSuccessfully: false,
        goods_nomenclature_code: "",
        additional_code_preview: "",
        additional_code: null,
        goods_nomenclature_code_description: "",
        additional_code_preview_description: "",
        additional_code_description: "",
        statuses: [
          { value: "open", label: "Open" },
          { value: "exhausted", label: "Exhausted" },
          { value: "critical", label: "Critical" },
          { value: "unblocked", label: "Unblocked" },
          { value: "unsuspended", label: "Unsuspended" },
          { value: "reopened", label: "Reopened" }
        ],
        origins: {
          country: {
            geographical_area_id: [],
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
        quota_sections: [],
        sub_quotas: {
          enabled: false,
          definitions: []
        },
        precisions: [
          { text: "1", value: 1 },
          { text: "2", value: 2 },
          { text: "3", value: 3 }
        ],
        errors: []
      };

      var default_quota = {
        operation_date: null,
        regulation_id: null,
        measure_type_id: null,
        quota_is_licensed: null,
        quota_licence: null,
        quota_ordernumber: null,
        quota_precision: null,
        quota_status: "open",
        quota_criticality_threshold: null,
        quota_description: null,
        geographical_area_id: null,
        excluded_geographical_areas: [],
        conditions: [],
        quota_periods: [],
        measure_components: [],
        footnotes: [],
        workbasket_name: null,
        reduction_indicator: null,
        commodity_codes: null,
        commodity_codes_exclusions: null,
        additional_codes: null,
        validity_start_date: null,
        validity_end_date: null,

        existing_quota: null,
        quota_sections: []
      };

      if (window.all_settings) {
        data.measure = jQuery.extend({}, default_quota, this.unwrapPayload(window.all_settings));

        if (window.all_settings.geographical_area_id) {
          if (window.all_settings.geographical_area_id == '1011') {
            data.origins.erga_omnes.selected = true;
            data.origins.erga_omnes.geographical_area_id = window.all_settings.geographical_area_id;

            if (window.all_settings.excluded_geographical_areas) {
              window.all_settings.excluded_geographical_areas.forEach(function(e) {
                data.origins.erga_omnes.exclusions.push({
                  geographical_area_id: e,
                  options: window.all_geographical_countries
                });
              });
            }
          } else {
            // country
            if (window.all_settings.geographical_area_id instanceof Array || window.geographical_areas_json[window.all_settings.geographical_area_id].length === 0) {
              data.origins.country.selected = true;
              data.origins.country.geographical_area_id = window.all_settings.geographical_area_id;
            } else {
              data.origins.group.selected = true;
              data.origins.group.geographical_area_id = window.all_settings.geographical_area_id;

              if (window.all_settings.excluded_geographical_areas) {
                window.all_settings.excluded_geographical_areas.forEach(function(e) {
                  data.origins.group.exclusions.push({
                    geographical_area_id: e,
                    options: window.geographical_areas_json[window.all_settings.geographical_area_id]
                  });
                });
              }
            }
          }
        }

        if (window.all_settings.quota_periods) {
          data.quota_sections = objectToArray(window.all_settings.quota_periods).map(function(section) {

            if (section.type == "custom") {
              section.repeat = section.repeat === "true";
              section.opening_balances = [];
              section.duty_expressions = [];

              section.periods = objectToArray(section.periods).map(function(period) {
                period.critical = period.critical === "true";

                period.duty_expressions = objectToArray(period.duty_expressions).map(function(e) {
                  delete e.$order;
                  e.duty_expression_id = self.getDutyExpressionId(e);

                  return e;
                });

                return period;
              });

            } else {
              section.critical = section.critical === "true";
              section.staged = section.staged === "true";
              section.criticality_each_period = section.criticality_each_period === "true";
              section.duties_each_period = section.duties_each_period === "true";
              section.periods = [];

              section.duty_expressions = objectToArray(section.duty_expressions).map(function(e) {
                delete e.$order;
                e.duty_expression_id = self.getDutyExpressionId(e);

                return e;
              });

              section.opening_balances = objectToArray(section.opening_balances).map(function(balance) {
                if (section.type == "annual") {
                  balance.critical = balance.critical === "true";

                  balance.duty_expressions = objectToArray(balance.duty_expressions).map(function(e) {
                    delete e.$order;
                    e.duty_expression_id = self.getDutyExpressionId(e);

                    return e;
                  });
                } else {
                  var ks = {
                    bi_annual: ["semester1", "semester2"],
                    quarterly: ["quarter1", "quarter2", "quarter3", "quarter4"],
                    monthly: ["month1", "month2", "month3", "month4", "month5", "month6", "month7", "month8", "month9", "month10", "month11", "month12"]
                  };

                  ks[section.type].forEach(function(k) {
                    balance[k].critical = balance[k].critical === "true";


                    balance[k].duty_expressions = objectToArray(balance[k].duty_expressions).map(function(e) {
                      delete e.$order;
                      e.duty_expression_id = self.getDutyExpressionId(e);

                      return e;
                    });
                  });
                }

                return balance;
              });
            }

            if (section.parent_quota.associate) {
              section.parent_quota.balances = objectToArray(section.parent_quota.balances);
            }

            return section;
          });
        }

        if (window.all_settings.sub_quotas) {
          data.sub_quotas.enabled = true;
          data.sub_quotas.definitions = window.all_settings.sub_quotas;
        }
      } else {
        data.measure = default_quota;
      }

      return data;
    },
    mounted: function() {
      var self = this;

      var saveFunction = function(e) {
        e.preventDefault();
        e.stopPropagation();

        submit_button = $(this);

        self.savedSuccessfully = false;
        WorkbasketBaseSaveActions.toogleSaveSpinner($(this).attr('name'));
        var http_method = "PUT";

        if (window.current_step == 'main') {
          var payload = self.createQuotaMainStepPayload();
        } else if (window.current_step == 'configure_quota') {
          var payload = self.createQuotaConfigureQuotaStepPayload();
        } else if (window.current_step == 'conditions_footnotes') {
          var payload = self.createQuotaConditionsFootnotesStepPayload();
        }

        var data_ops = {
          step: window.current_step,
          mode: submit_button.attr('name'),
          start_date: window.create_measures_start_date,
          end_date: window.create_measures_end_date,
          settings: payload
        };

        self.errors = [];

        $.ajax({
          url: window.save_url,
          type: http_method,
          data: data_ops,
          success: function(response) {
            WorkbasketBaseSaveActions.handleSuccessResponse(response, submit_button.attr('name'), function() {
              self.savedSuccessfully = true;
            });
          },
          error: function(response) {
            self.savedSuccessfully = true;
            WorkbasketBaseValidationErrorsHandler.handleErrorsResponse(response, self);
          }
        });
      };

      $(document).on('click', ".js-create-measures-v1-submit-button, .js-workbasket-base-submit-button", debounce(saveFunction, 100, true));

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
          duty_amount: null,
          measurement_unit_code: null,
          measurement_unit_qualifier_code: null
        });
      }

      this.fetchNomenclatureCode("/goods_nomenclatures", 10, "goods_nomenclature_code", "goods_nomenclature_code_description");
      this.fetchAdditionalCode("/additional_codes/preview", 4, "additional_code_preview", "additional_code_preview_description");

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
      fetchAdditionalCode: function(url, length, code, description, type, description_field) {
        var self = this;
        if (this[code].trim().length === length) {
          $.ajax({
            url: url,
            data: {
              code: this[code].trim()
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
      unwrapPayload: function(payload) {
        var self = this;

        var measure = {
          operation_date: payload.operation_date,
          validity_start_date: payload.start_date,
          validity_end_date: payload.end_date,
          regulation_id: payload.regulation_id,
          measure_type_id: payload.measure_type_id,
          workbasket_name: payload.workbasket_name,
          reduction_indicator: payload.reduction_indicator,
          additional_codes: payload.additional_codes,
          commodity_codes: payload.commodity_codes,
          commodity_codes_exclusions: payload.commodity_codes_exclusions,
          quota_ordernumber: payload.quota_ordernumber,
          quota_precision: payload.quota_precision,
          quota_is_licensed: payload.quota_is_licensed === "true",
          quota_licence: payload.quota_licence,
          quota_description: payload.quota_description,
          footnotes: [],
          measure_components: [],
          conditions: []
        };

        if (payload.footnotes) {
          for (var k in payload.footnotes) {
            if (!payload.footnotes.hasOwnProperty(k)) {
              continue;
            }

            measure.footnotes.push(clone(payload.footnotes[k]));
          }
        }

        if (payload.measure_components) {
          for (var k in payload.measure_components) {
            if (!payload.measure_components.hasOwnProperty(k)) {
              continue;
            }

              var component = clone(payload.measure_components[k]);

              if (component.duty_expression_id) {
                component.duty_expression_id = self.getDutyExpressionId(component);
              }

              measure.measure_components.push(component);
          };
        }

        if (payload.conditions) {
          for (var k in payload.conditions) {
            if (!payload.conditions.hasOwnProperty(k)) {
              continue;
            }

            var condition = clone(payload.conditions[k]);
            condition.condition_code = ConditionsParser.getConditionCode(condition);

            if (condition.measure_condition_components) {
              var mcc = [];

              for (var kk in condition.measure_condition_components) {
                if (!condition.measure_condition_components.hasOwnProperty(kk)) {
                  continue;
                }

                var component = clone(condition.measure_condition_components[kk]);

                if (component.duty_expression_id) {
                  component.duty_expression_id = self.getDutyExpressionId(component);
                }

                mcc.push(component);
              }

              condition.measure_condition_components = mcc;
            }

            measure.conditions.push(condition);
          }
        }

        if (window.measure_types_json) {
          window.measure_types_json.forEach(function(mt) {
            if (mt.measure_type_id == payload.measure_type_id) {
              measure.measure_type_series_id = mt.measure_type_series_id;
            }
          });
        }

        return measure;
      },
      createQuotaMainStepPayload: function() {
        var payload = {
          operation_date: this.measure.operation_date,
          regulation_id: this.measure.regulation_id,
          measure_type_id: this.measure.measure_type_id,
          quota_ordernumber: this.measure.quota_ordernumber,
          quota_description: this.measure.quota_description,
          quota_is_licensed: this.measure.quota_is_licensed,
          quota_licence: this.measure.quota_licence,
          reduction_indicator: this.measure.reduction_indicator,
          additional_codes: this.measure.additional_codes,
          commodity_codes: this.measure.commodity_codes,
          commodity_codes_exclusions: this.measure.commodity_codes_exclusions
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

        return payload;
      },
      createQuotaConfigureQuotaStepPayload: function() {
        var payload = {
          quota_periods: this.quota_sections.filter(function(section) {
            return section.type;
          }).map(function(_section) {
            var section = clone(_section);

            section.duty_expressions.forEach(function(e) {
              e.original_duty_expression_id = e.duty_expression_id.slice(0);
              e.duty_expression_id = e.duty_expression_id.substring(0,2);
            });

            if (section.type == "custom") {
              delete section.opening_balances;
              delete section.critical;
              delete section.criticality_threshold;
              delete section.duties_each_period;
              delete section.criticality_each_period;
              delete section.staged;
              delete section.start_date;
              delete section.period;

              section.periods.forEach(function(period) {
                period.duty_expressions.forEach(function(e) {
                  e.original_duty_expression_id = e.duty_expression_id.slice(0);
                  e.duty_expression_id = e.duty_expression_id.substring(0,2);
                });
              });
            } else {
              delete section.periods;
              delete section.repeat;

              section.opening_balances.forEach(function(balance) {
                if (section.type == "annual") {
                  balance.duty_expressions.forEach(function(e) {
                    e.original_duty_expression_id = e.duty_expression_id.slice(0);
                    e.duty_expression_id = e.duty_expression_id.substring(0,2);
                  });
                } else {
                  var ks = {
                    bi_annual: ["semester1", "semester2"],
                    quarterly: ["quarter1", "quarter2", "quarter3", "quarter4"],
                    monthly: ["month1", "month2", "month3", "month4", "month5", "month6", "month7", "month8", "month9", "month10", "month11", "month12"]
                  };

                  ks[section.type].forEach(function(k) {
                    balance[k].duty_expressions.forEach(function(e) {
                      e.original_duty_expression_id = e.duty_expression_id.slice(0);
                      e.duty_expression_id = e.duty_expression_id.substring(0,2);
                    });
                  });
                }
              });
            }

            return section;
          })
        };

        return payload;
      },
      createQuotaConditionsFootnotesStepPayload: function() {
        var payload = {
          footnotes: this.measure.footnotes,
          sub_quotas: this.sub_quotas.enabled ? this.sub_quotas.definitions : []
        };

        try {
          payload.conditions = this.measure.conditions.map(function(condition) {
            var c = clone(condition);

            c.original_measure_condition_code = c.condition_code.slice(0);
            c.condition_code = c.condition_code.substring(0, 1);

            c.measure_condition_components = c.measure_condition_components.map(function(component) {
              var c = clone(component);
              if (c.duty_expression_id) {
                c.original_duty_expression_id = c.duty_expression_id.slice(0);
                // to ignore A and B
                c.duty_expression_id = c.duty_expression_id.substring(0, 2);
              }

              return c;
            });

            return c;
          });
        } catch (e) {
          console.error(e);
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
      getDutyExpressionId: function(component) {
        var ids = [
          "01",
          "02",
          "04",
          "15",
          "17",
          "19",
          "20",
          "35",
          "36"
        ];

        if (component.original_duty_expression_id) {
          return component.original_duty_expression_id;
        }

        var id = component.duty_expression ? component.duty_expression.duty_expression_id : component.duty_expression_id;

        if (ids.indexOf(id) === -1) {
          return id;
        }

        if (component.monetary_unit || component.monetary_unit_code) {
          return id + "B";
        }

        return id + "A";
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
      },
      disableButtons: function() {
        if (!this.measure.measure_type_id) {
          return true;
        }

        if (window.current_step == "configure_quota") {
          if (this.quota_sections.length === 1 && !this.quota_sections[0].type) {
            return true;
          }
        }

        return false;
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
      additional_code_preview: function() {
        this.fetchAdditionalCode("/additional_codes/preview", 4, "additional_code_preview", "additional_code_preview_description");
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
      },
      "measure.quota_is_licensed": function(newVal)  {
        if (!newVal) {
          this.measure.quota_licence = null;
        }
      }
    }
  });
});
