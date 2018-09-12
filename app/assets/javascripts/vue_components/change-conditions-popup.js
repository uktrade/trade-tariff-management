Vue.component("change-conditions-popup", {
  template: "#change-conditions-popup-template",
  props: ["measures", "onClose", "open", "index"],
  data: function() {
    return {
      conditions: [],
      replacing: false,
      errors: [],
      mode: null
    };
  },
  mounted: function() {
    var self = this;
    var equal = true;
    var n = this.measures.length;
    var count = this.measures[0].measure_conditions.length;

    for (var i = 1; i < n; i++) {
      if (count != this.measures[i].measure_conditions.length) {
        equal = false;
        break;
      }
    }

    // count is equal
    if (equal) {
      for (var i = 0; i < count; i++) {
        var first = this.normalizeCondition(this.measures[0].measure_conditions[i]);

        for (var j = 1; j < n; j++) {
          var current = this.normalizeCondition(this.measures[j].measure_conditions[i]);

          if (!this.equivalent(first, current)) {
            equal = false;
            break;
          }
        }
      }
    }

    this.replacing = !equal;

    if (equal) {
      var normalizeFunc = this.normalizeCondition.bind(this);
      this.conditions = this.measures[0].measure_conditions.map(function(condition) {
        var newCondition = normalizeFunc(condition);

        if (newCondition.measure_condition_components.length === 0) {
          newCondition.measure_condition_components.push({
            duty_expression_id: null,
            duty_amount: null,
            measurement_unit_code: null,
            measurement_unit_qualifier_code: null,
            duty_expression: null,
            measurement_unit: null,
            measurement_unit_qualifier: null,
            monetary_unit: null,
            monetary_unit_code: null
          });
        }

        return newCondition;
      });

      if (this.measures[0].measure_conditions.length === 0) {
        this.addCondition();
      }
    } else {
      this.addCondition();
    }
  },
  computed: {
    multiple: function() {
      return this.measures.length > 1;
    },
    canRemoveMeasureCondition: function() {
      return this.conditions.length > 1;
    },
    disableUpdate: function() {
      return this.replacing && this.mode == null;
    }
  },
  methods: {
    normalizeComponent: function(component) {
      return {
        duty_expression_id: this.getDutyExpressionId(component),
        duty_amount: component.duty_amount,
        measurement_unit_code: component.measurement_unit ? component.measurement_unit.measurement_unit_code : null,
        measurement_unit_qualifier_code: component.measurement_unit_qualifier ? component.measurement_unit_qualifier.measurement_unit_qualifier_code : null,
        duty_expression: component.duty_expression,
        measurement_unit: component.measurement_unit,
        measurement_unit_qualifier: component.measurement_unit_qualifier,
        monetary_unit: component.monetary_unit,
        monetary_unit_code: component.monetary_unit ? component.monetary_unit.monetary_unit_code : null
      };
    },
    normalizeCondition: function(condition) {
      return {
        measure_condition_code: condition.measure_condition_code,
        condition_code: this.getConditionComponent(condition),
        action_code: condition.measure_action ? condition.measure_action.action_code : null,
        measure_action: condition.measure_action,
        certificate_type_id: condition.certificate_type ? condition.certificate_type.certificate_type_id : null,
        certificate_id: condition.certificate ? condition.certificate_id : null,
        certificate_type: condition.certificate_type,
        certificate: condition.certificate,
        measure_condition_components: condition.measure_condition_components.filter(function(mcc) {
          return mcc.duty_expression;
        }).map(this.normalizeComponent)
      };
    },
    equivalent: function(c1, c2) {
      var str_c1 = JSON.stringify(c1.measure_condition_components);
      var str_c2 = JSON.stringify(c2.measure_condition_components);

      if (c1.action_code != c2.action_code ||
          c1.condition_code != c2.condition_code ||
          c1.certificate_type_id != c2.certificate_type_id ||
          c1.certificate_id != c2.certificate_id ||
          str_c1 != str_c2) {
            return false;
      }

      return true;
    },
    validate: function() {
      var errors = [];

      this.errors = errors;

      return errors.length === 0;
    },
    getDutyExpressionId: function(component) {
      var ids = ["01","02","04","19","20"];
      var id = component.duty_expression.duty_expression_id;

      if (component.original_duty_expression_id) {
        return component.original_duty_expression_id;
      }

      if (ids.indexOf(component.duty_expression.duty_expression_id) === -1) {
        return id;
      }

      if (component.monetary_unit) {
        return id + "B";
      }

      return id + "A";
    },
    getConditionComponent: function(condition) {
      if (condition.original_measure_condition_code) {
        return condition.original_measure_condition_code;
      }

      return condition.measure_condition_code ? condition.measure_condition_code.condition_code : null;
    },
    confirmChanges: function() {
      var conditions = this.conditions;
      var self = this;

      if (!this.validate()) {
        return;
      }

      if (!this.replacing || (this.replacing && this.mode == "replace")) {
        this.measures.forEach(function(measure) {
          if (measure.changes.indexOf("conditions") === -1) {
            measure.changes.push("conditions");
          }

          measure.measure_conditions.splice(0, measure.measure_conditions.length);

          conditions.forEach(function(c) {
            condition = clone(c)
            // this will take care of second radio button instructing
            // users to leave blank to remove all conditions
            if (!condition.condition_code) {
              return;
            }

            condition.original_measure_condition_code = condition.condition_code.slice(0);
            condition.condition_code = condition.condition_code.substring(0, 1);

            condition.measure_condition_components.forEach(function(mcc) {
              mcc.original_duty_expression_id = mcc.duty_expression_id.slice(0);
              mcc.duty_expression_id = mcc.duty_expression_id.substring(0,2);
              mcc.duty_expression.duty_expression_id = mcc.duty_expression.duty_expression_id.substring(0,2);
            });

            measure.measure_conditions.push(condition);
          });
        });
      } else {
        // Existing conditions will be retained. Conditions specified here will not be added to any measures in which the exact same condition already exists.

        this.measures.forEach(function(measure) {
          if (measure.changes.indexOf("conditions") === -1) {
            measure.changes.push("conditions");
          }

          conditions.forEach(function(condition) {
            if (!condition.condition_code) {
              return;
            }

            condition.original_measure_condition_code = condition.condition_code.slice(0);
            condition.condition_code = condition.condition_code.substring(0, 1);

            condition.measure_condition_components.forEach(function(mcc) {
              mcc.original_duty_expression_id = mcc.duty_expression_id.slice(0);
              mcc.duty_expression_id = mcc.duty_expression_id.substring(0,2);
              mcc.duty_expression.duty_expression_id = mcc.duty_expression.duty_expression_id.substring(0,2);
            });

            var found = false;

            measure.measure_conditions.forEach(function(mc) {
              if (self.equivalent(condition, mc)) {
                found = true;
              }
            });

            if (!found) {
              measure.measure_conditions.push(condition);
            }
          })
        });
      }

      this.$emit("measures-updated");
      this.onClose();
    },
    triggerClose: function() {
      this.onClose();
    },
    addCondition: function() {
      this.conditions.push({
        id: null,
        condition_code: null,
        action_code: null,
        certificate_type_id: null,
        certificate_id: null,
        certificate_type: null,
        certificate: null,
        measure_action: null,
        measure_condition: null,
        measure_condition_components: [
          {
            duty_expression_id: null,
            duty_amount: null,
            monetary_unit_code: null,
            measurement_unit_code: null,
            measurement_unit_qualifier_code: null,
            duty_expression: null,
            measurement_unit: null,
            measurement_unit_qualifier: null,
            monetary_unit: null
          }
        ]
      });
    },
    removeCondition: function(condition, indes) {
      this.conditions.splice(index, 1);
    }
  }
});
