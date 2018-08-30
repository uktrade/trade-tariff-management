//= require ../components/duty-expressions-parser

var componentCommonFunctionality = {
  methods: {
    expressionsFriendlyDuplicate: function(options) {
      return DutyExpressionsParser.parse(options);
    },
    onDutyExpressionSelected: function(item) {
      this[this.thing].duty_expression = item;
    },
    onMonetaryUnitSelected: function(item) {
      this[this.thing].monetary_unit = item;
    },
    onMeasurementUnitSelected: function(item) {
      this[this.thing].measurement_unit = item;
    },
    onMeasurementUnitQualifierSelected: function(item) {
      this[this.thing].measurement_unit_qualifier = item;
    }
  },
  watch: {
    showMeasurementUnit: function(val) {
      if (!val) {
        this[this.thing].measurement_unit_code = undefined;
        this[this.thing].measurement_unit_qualifier_code = undefined;
        this[this.thing].measurement_unit = undefined;
        this[this.thing].measurement_unit_qualifier = undefined;
      }
    },
    showMonetaryUnit: function(val) {
      if (!val) {
        this[this.thing].monetary_unit = null;
        this[this.thing].monetary_unit_code = null;
      }
    }
  }
};

Vue.component("measure-component", $.extend({}, {
  template: "#measure-component-template",
  props: [
    "measureComponent",
    "index",
    "hideHelp",
    "roomDutyAmount",
    "roomMonetaryUnit",
    "roomMeasurementUnit"
  ],
  data: function() {
    return {
      thing: "measureComponent"
    };
  },
  computed: {
    showMonetaryUnit: function() {
      return false;
    },
    showDutyAmount: function() {
      var ids = ["12", "14", "21", "25", "27", "29", "37", "99"];
      return this.measureComponent.duty_expression_id && ids.indexOf(this.measureComponent.duty_expression_id) === -1;
    },
    showMeasurementUnit: function() {
      var ids = ["12", "14", "21", "23", "25", "27", "29", "36", "37", "01A", "02A", "04A", "15A", "17A", "19A", "20A", "35A"];

      return this.measureComponent.duty_expression_id && ids.indexOf(this.measureComponent.duty_expression_id) === -1;
    }
  }
}, componentCommonFunctionality));

Vue.component("measure-condition-component", $.extend({}, {
  template: "#measure-condition-component-template",
  props: [
    "measureConditionComponent",
    "index",
    "hideHelp",
    "roomDutyAmount",
    "roomMonetaryUnit",
    "roomMeasurementUnit"
  ],
  data: function() {
    return {
      thing: "measureConditionComponent"
    };
  },
  computed: {
    showMonetaryUnit: function() {
      return false;
    },
    showDutyAmount: function() {
      var ids = ["12", "14", "21", "25", "27", "29", "37", "99"];
      return this.measureConditionComponent.duty_expression_id && ids.indexOf(this.measureConditionComponent.duty_expression_id) === -1;
    },
    showMeasurementUnit: function() {
      var ids = ["12", "14", "21", "23", "25", "27", "29", "36", "37", "01A", "02A", "04A", "15A", "17A", "19A", "20A", "35A"];
      return this.measureConditionComponent.duty_expression_id && ids.indexOf(this.measureConditionComponent.duty_expression_id) === -1;
    }
  }
}, componentCommonFunctionality));
