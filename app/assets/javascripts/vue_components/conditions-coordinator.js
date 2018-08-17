var template = [
  '<div>',
    '<div class="measure-condition" v-for="(measureCondition, index) in conditions">',
      '<measure-condition :condition="measureCondition" :index="index" :hide-help="hideHelp" :room-action="showAction" :room-condition-components="showConditionComponents" :room-minimum-price="showMinimumPrice" :room-ratio="showRatio" :room-entry-price="showEntryPrice" :room-amount="showAmount" :room-certificate-type="showCertificateType" :room-certificate="showCertificate" :room-maximum-price-per-unit="showMaximumPricePerUnit" :room-maximum-quantity="showMaximumQuantity" :room-monetary-unit="showMonetaryUnit" :room-measurement-unit="showMeasurementUnit">',
        '<div class="col-md-2">',
          '<div class="form-group">',
            '<label for="" class="form-label" v-if="index == 0">&nbsp;<span class="form-hint-3-line">&nbsp;</span></label>',
            '<a class="secondary-button text-danger" href="#" v-on:click.prevent="removeCondition(measureCondition, index)" v-if="canRemoveMeasureCondition">',
              'Remove condition',
            '</a>',
          '</div>',
        '</div>',
      '</measure-condition>',
    '</div>',
    '<p>',
      '<a href="#" v-on:click.prevent="addCondition">Add another condition</a>',
    '</p>',
  '</div>'
].join("");

Vue.component("conditions-coordinator", {
  template: template,
  props: ["conditions", "hideHelp"],
  data: function() {
    return {

    };
  },
  methods: {
    any: function(arr, func) {
      return arr.filter(function(condition) {
        return func(condition);
      }).length > 0;
    },
    removeCondition: function(condition, index) {
      this.conditions.splice(index, 1);
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
            amount: null,
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
    }
  },
  computed: {
    canRemoveMeasureCondition: function() {
      return this.conditions.length > 1;
    },
    showMaximumQuantity: function() {
      var codes = ["E1", "I1"];

      return this.any(this.conditions, function(condition) {
        return condition.condition_code && codes.indexOf(condition.condition_code) > -1;
      });
    },
    showMaximumPricePerUnit: function() {
      var codes = ["E2", "I2"];

      return this.any(this.conditions, function(condition) {
        return condition.condition_code && codes.indexOf(condition.condition_code) > -1;
      });
    },
    showMonetaryUnit: function() {
      var codes = ["E2", "I2", "M1", "M2"];

      return this.any(this.conditions, function(condition) {
        return condition.condition_code && codes.indexOf(condition.condition_code) > -1;
      });
    },
    showMeasurementUnit: function() {
      var codes = ["E2", "I2", "M1", "M2"];

      return this.any(this.conditions, function(condition) {
        return condition.condition_code && codes.indexOf(condition.condition_code) > -1;
      });
    },
    showAction: function() {
      var codes = ["K", "P", "S", "W", "Y"];

      return this.any(this.conditions, function(condition) {
        return condition.condition_code && codes.indexOf(condition.condition_code) === -1;
      });
    },
    showConditionComponents: function() {
      var codes = ["01", "02", "03", "11", "12", "13", "15", "27", "34", "36"];

      return this.any(this.conditions, function(condition) {
        return codes.indexOf(condition.action_code) > -1;
      });
    },
    showMinimumPrice: function() {
      var codes = ["F", "G", "L", "N"];

      return this.any(this.conditions, function(condition) {
        return codes.indexOf(condition.condition_code) > -1;
      });
    },
    showRatio: function() {
      var codes = ["R", "U"];

      return this.any(this.conditions, function(condition) {
        return codes.indexOf(condition.condition_code) > -1;
      });
    },
    showEntryPrice: function() {
      var codes = ["V"];

      return this.any(this.conditions, function(condition) {
        return codes.indexOf(condition.condition_code) > -1;
      });
    },
    showAmount: function() {
      var codes = ["E", "I", "M"];

      return this.any(this.conditions, function(condition) {
        return codes.indexOf(condition.condition_code) > -1;
      });
    },
    showCertificateType: function() {
      var codes = ["B", "C", "E3", "I3", "H", "Q", "Z", "V", "E"];

      return this.any(this.conditions, function(condition) {
        return codes.indexOf(condition.condition_code) > -1;
      });
    },
    showCertificate: function() {
      var codes = ["A", "B", "C", "E3", "I3", "H", "Q", "Z", "V", "E"];

      return this.any(this.conditions, function(condition) {
        return codes.indexOf(condition.condition_code) > -1;
      });
    }
  }
});
