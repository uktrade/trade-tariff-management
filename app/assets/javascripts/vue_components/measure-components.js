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
