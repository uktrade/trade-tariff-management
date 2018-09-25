Vue.component("change-duties-popup", {
  template: "#change-duties-popup-template",
  props: ["measures", "onClose", "open"],
  data: function() {
    return {
      measureComponents: [],
      replacing: false,
      errors: []
    };
  },
  mounted: function() {
    var self = this;
    var equal = true;
    var n = this.measures.length;
    var dtCount = this.measures[0].measure_components.length;

    for (var i = 1; i < n; i++) {
      if (dtCount != this.measures[i].measure_components.length) {
        equal = false;
        break;
      }
    }

    // count is equal
    if (equal) {
      var simplifyAndJson = function(components) {
        return JSON.stringify(components.map(function(component) {
          return {
            duty_expression_id: component.duty_expression_id,
            duty_amount: component.duty_amount,
            monetary_unit_id: component.monetary_unit_id,
            measurement_unit_id: component.measurement_unit_id,
            measurement_unit_qualifier_id: component.measurement_unit_qualifier_id,
          };
        }));
      };

      var fmd = simplifyAndJson(this.measures[0].measure_components);

      for (var i = 1; i < dtCount; i++) {
        if (fmd != simplifyAndJson(this.measures[i].measure_components)) {
          equal = false;
          break;
        }
      }
    }

    this.replacing = !equal;

    if (equal) {
      this.measureComponents = this.measures[0].measure_components.map(function(component) {
        return {
          duty_expression_id: self.getDutyExpressionId(component),
          duty_amount: component.duty_amount,
          measurement_unit_code: component.measurement_unit ? component.measurement_unit.measurement_unit_code : null,
          measurement_unit_qualifier_code: component.measurement_unit_qualifier ? component.measurement_unit_qualifier.measurement_unit_qualifier_code : null,
          duty_expression: component.duty_expression,
          measurement_unit: component.measurement_unit,
          measurement_unit_qualifier: component.measurement_unit_qualifier,
          monetary_unit: component.monetary_unit,
          monetary_unit_code: component.monetary_unit ? component.monetary_unit.monetary_unit_code : null
        };
      });

      if (this.measures[0].measure_components.length === 0) {
        this.addDutyExpression();
      }
    } else {
      this.addDutyExpression();
    }
  },
  computed: {
    multiple: function() {
      return this.measures.length > 1;
    },
    canRemoveMeasureComponent: function() {
      return this.measureComponents.length > 1;
    }
  },
  methods: {
    validate: function() {
      var errors = [];
      var amountRegex = new RegExp(/^([\d]+)[\.]?[\d]*$/);

      this.measureComponents.forEach(function(mc, index) {
        var ids = ["12", "14", "21", "25", "27", "29", "37", "99"];

        if (!mc.duty_expression_id || ids.indexOf(mc.duty_expression_id) > -1) {
          return;
        }

        if (!amountRegex.test('' + mc.duty_amount)) {
          errors.push("Amount field for " + ordinal(index + 1) + " duty expression is invalid");
        }
      });

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
    confirmChanges: function() {
      var components = this.measureComponents;

      if (!this.validate()) {
        return;
      }

      this.measures.forEach(function(measure) {
        if (measure.changes.indexOf("duties") === -1) {
          measure.changes.push("duties");
        }

        measure.measure_components.splice(0, 999);

        components.forEach(function(component) {
          component.duty_expression.duty_expression_id = component.duty_expression.duty_expression_id.substring(0,2);

          measure.measure_components.push({
            duty_amount: component.duty_amount,
            duty_expression: component.duty_expression,
            measurement_unit: component.measurement_unit,
            measurement_unit_qualifier: component.measurement_unit_qualifier,
            monetary_unit: component.monetary_unit,
            original_duty_expression_id: component.duty_expression_id.slice(0),
            duty_expression_id: component.duty_expression_id.substring(0,2)
          });
        });
      });

      this.$emit("measures-updated");
      this.onClose();
    },
    triggerClose: function() {
      this.onClose();
    },
    addDutyExpression: function() {
      this.measureComponents.push({
        duty_expression_id: null,
        duty_amount: null,
        monetary_unit_code: null,
        measurement_unit_code: null,
        measurement_unit_qualifier_code: null,
        duty_expression: null,
        measurement_unit: null,
        measurement_unit_qualifier: null,
        monetary_unit: null
      });
    },
    removeMeasureComponent: function(measureComponent, index) {
      this.measureComponents.splice(index, 1);
    }
  }
});
