Vue.component("change-duties-popup", {
  template: "#change-duties-popup-template",
  props: ["measures", "onClose", "open"],
  data: function() {
    return {
      measureComponents: [],
      replacing: false
    };
  },
  mounted: function() {
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
      for (var i = 0; i < dtCount; i++) {
        var dutyExpressionId = this.measures[0].measure_components[0].duty_expression_id;
        var dutyExpressionAmount = this.measures[0].measure_components[0].amount;
        var dutyExpressionMonetaryUnit = this.measures[0].measure_components[0].monetary_unit_id;
        var dutyExpressionMeasurementUnit = this.measures[0].measure_components[0].measurement_unit_id;
        var dutyExpressionMeasurementUnitQualifier = this.measures[0].measure_components[0].measurement_unit_qualifier_id;

        for (var j = 1; j < n; j++) {
          if (dutyExpressionId != this.measures[j].measure_components[i].duty_expression_id ||
              dutyExpressionAmount != this.measures[j].measure_components[i].amount ||
              dutyExpressionMonetaryUnit != this.measures[j].measure_components[i].monetary_unit_id ||
              dutyExpressionMeasurementUnit != this.measures[j].measure_components[i].measurement_unit_id ||
              dutyExpressionMeasurementUnitQualifier != this.measures[j].measure_components[i].measurement_unit_qualifier_id) {
                equal = false;
                break;
              }
        }
      }
    }

    this.replacing = !equal;

    if (equal) {
      this.measureComponents = this.measures[0].measure_components;
    }
  },
  computed: {
    multiple: function() {
      return this.measures.length > 1;
    }
  },
  methods: {
    confirmChanges: function() {
      this.onConfirm(this.measureComponents);
    },
    triggerClose: function() {
      this.onClose();
    },
    addDutyExpression: function() {
      this.measureComponents.push({
        duty_expression_id: null,
        amount: null,
        measurement_unit_code: null,
        measurement_unit_qualifier_code: null
      });
    }
  }
});
