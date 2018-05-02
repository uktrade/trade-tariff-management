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
      var newOptions = [];

      options.forEach(function(option) {
        option.duty_expression_code = option.duty_expression_id;
        var newOption = null;

        if (option.duty_expression_id === "01") {
          option.duty_expression_id = "01A";
          option.description = "% (ad valorem)";
          option.abbreviation = "+ %";

          newOption = {
            duty_expression_code: option.duty_expression_code,
            duty_expression_id: "01B",
            description: "Specific duty rate",
            abbreviation: "+ €"
          };
        } else if (option.duty_expression_id === "02") {
          option.duty_expression_id = "02A";
          option.description = "Minus %";
          option.abbreviation = "- %";

          newOption = {
            duty_expression_code: option.duty_expression_code,
            duty_expression_id: "02B",
            description: "Minus amount",
            abbreviation: "- €"
          };
        } else if (option.duty_expression_id === "04") {
          option.duty_expression_id = "04A";
          option.description = "Plus %";
          option.abbreviation = "+ %";

          newOption = {
            duty_expression_code: option.duty_expression_code,
            duty_expression_id: "04B",
            description: "Plus amount",
            abbreviation: "+ €"
          };
        } else if (option.duty_expression_id === "19") {
          option.duty_expression_id = "19A";
          option.description = "Plus %";
          option.abbreviation = "+ %";

          newOption = {
            duty_expression_code: option.duty_expression_code,
            duty_expression_id: "19B",
            description: "Plus amount",
            abbreviation: "+ €"
          };
        } else if (option.duty_expression_id === "20") {
          option.duty_expression_id = "20A";
          option.description = "Plus %";
          option.abbreviation = "+ %";

          newOption = {
            duty_expression_code: option.duty_expression_code,
            duty_expression_id: "20B",
            description: "Plus amount",
            abbreviation: "+ €"
          };
        }

        newOptions.push(option);

        if (newOption) {
          newOptions.push(newOption);
        }
      });


      return newOptions;
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
