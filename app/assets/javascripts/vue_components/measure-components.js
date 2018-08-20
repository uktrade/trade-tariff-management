//= require ../components/duty-expressions-parser

var componentCommonFunctionality = {
  computed: {
    showDutyAmountOrPercentage: function() {
      var ids = ["01", "02", "04", "19", "20"];

      return ids.indexOf(this[this.thing].duty_expression_id) > -1;
    },
    showDutyAmountPercentage: function() {
      var ids = ["23", "01A", "04A", "19A", "20A"];

      return ids.indexOf(this[this.thing].duty_expression_id) > -1;
    },
    showDutyAmountNegativePercentage: function() {
      var ids = ["36", "02A"];

      return ids.indexOf(this[this.thing].duty_expression_id) > -1;
    },
    showDutyAmountNumber: function() {
      var ids = ["01B", "04B", "19B", "20B", "06", "07", "09", "11", "12", "13", "14", "21", "25", "27", "29", "31"];

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
    showDutyAmountNegativeNumber: function() {
      var ids = ["02B"];

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
      var ids = ["23", "36", "37", "01A", "04A", "19A", "20A", "02A"];

      return this[this.thing].duty_expression_id && ids.indexOf(this[this.thing].duty_expression_id) === -1;
    }
  },
  methods: {
    expressionsFriendlyDuplicate: function(options) {
      return DutyExpressionsParser.parse(options);
    },
    onDutyExpressionSelected: function(item) {
      this[this.thing].duty_expression = item;

      if (!this.showMonetaryUnit) {
        this[this.thing].monetary_unit = null;
        this[this.thing].monetary_unit_code = null;
      }

      if (!this.showMeasurementUnit) {
        this[this.thing].measurement_unit_code = null;
        this[this.thing].measurement_unit_qualifier_code = null;
        this[this.thing].measurement_unit = null;
        this[this.thing].measurement_unit_qualifier = null;
      }
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
  }
};

Vue.component("measure-component", $.extend({}, {
  template: "#measure-component-template",
  props: [
    "measureComponent",
    "index",
    "hideHelp",
    "roomDutyAmountOrPercentage",
    "roomDutyAmountPercentage",
    "roomDutyAmountNegativePercentage",
    "roomDutyAmountNumber",
    "roomDutyAmountMinimum",
    "roomDutyAmountMaximum",
    "roomDutyAmountNegativeNumber",
    "roomDutyRefundAmount",
    "roomMonetaryUnit",
    "roomMeasurementUnit"
  ],
  data: function() {
    return {
      thing: "measureComponent"
    };
  }
}, componentCommonFunctionality));

Vue.component("measure-condition-component", $.extend({}, {
  template: "#measure-condition-component-template",
  props: [
    "measureConditionComponent",
    "index",
    "hideHelp",
    "roomDutyAmountOrPercentage",
    "roomDutyAmountPercentage",
    "roomDutyAmountNegativePercentage",
    "roomDutyAmountNumber",
    "roomDutyAmountMinimum",
    "roomDutyAmountMaximum",
    "roomDutyAmountNegativeNumber",
    "roomDutyRefundAmount",
    "roomMonetaryUnit",
    "roomMeasurementUnit"
  ],
  data: function() {
    return {
      thing: "measureConditionComponent"
    };
  },
  computed: {
    hideHelp: function() {
      return this.index > 0;
    }
  }
}, componentCommonFunctionality));
