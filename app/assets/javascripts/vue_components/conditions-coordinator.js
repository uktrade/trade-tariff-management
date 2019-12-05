var template = [
  '<div>',
    '<div class="measure-condition" v-for="(measureCondition, index) in conditions">',
      '<measure-condition :condition="measureCondition" :id="\'measure-condition-\' + index" :index="index" :hide-help="hideHelp" :room-referenced-value="showReferencedValue" :room-certificate-type="showCertificateType" :room-certificate="showCertificate" :room-monetary-unit="showMonetaryUnit" :room-measurement-unit="showMeasurementUnit" :show-conditions-duty-amount="showConditionsDutyAmount" :show-conditions-measurement-unit="showConditionsMeasurementUnit">',
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
      '<a href="#" v-on:click.prevent="addCondition">Add condition</a>',
    '</p>',
  '</div>'
].join("");

Vue.component("conditions-coordinator", {
  template: template,
  props: ["conditions", "hideHelp", "components"],
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
      return (this.conditions.length > 1) || (this.conditions[0].condition_code);
    },
    showReferencedValue: function() {
      var codes = ["E1", "E2", "F", "G", "I1", "I2", "L", "M1", "M2", "N", "R", "S", "U", "V"];

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
      var codes = ["E1", "E2", "F", "G", "I1", "I2", "L", "M1", "M2", "N", "S", "V"];

      return this.any(this.conditions, function(condition) {
        return condition.condition_code && codes.indexOf(condition.condition_code) > -1;
      });
    },
    showCertificateType: function() {
      var codes = ["A", "B", "C", "E3", "I3", "H", "K", "P", "Q", "R", "Y", "Z"];

      return this.any(this.conditions, function(condition) {
        return codes.indexOf(condition.condition_code) > -1;
      });
    },
    showCertificate: function() {
      var codes = ["A", "B", "C", "E3", "I3", "H", "K", "P", "Q", "R", "Y", "Z"];

      return this.any(this.conditions, function(condition) {
        return codes.indexOf(condition.condition_code) > -1;
      });
    },
    showConditionsDutyAmount: function() {
      var ids = ["12", "14", "21", "25", "27", "29", "37", "99"];
      var any = this.any;

      return any(this.conditions, function(condition) {
        return any(condition.measure_condition_components, function(component) {
          return component.duty_expression_id && ids.indexOf(component.duty_expression_id) === -1;
        });
      });
    },
    showConditionsMeasurementUnit: function() {
      var ids = ["12", "14", "21", "23", "25", "27", "29", "36", "37", "01A", "02A", "04A", "15A", "17A", "19A", "20A", "35A"];

      var any = this.any;

      return any(this.conditions, function(condition) {
        return any(condition.measure_condition_components, function(component) {
          return component.duty_expression_id && ids.indexOf(component.duty_expression_id) === -1;
        });
      });
    }
  }
});
