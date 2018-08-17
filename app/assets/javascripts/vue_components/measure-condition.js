//= require ../components/conditions-parser

Vue.component('measure-condition', {
  template: "#condition-template",
  props: [
    "condition",
    "hideHelp",
    "index",
    "roomAction",
    "roomConditionComponents",
    "roomMinimumPrice",
    "roomRatio",
    "roomEntryPrice",
    "roomAmount",
    "roomMonetaryUnit",
    "roomCertificateType",
    "roomCertificate",
    "roomMaximumQuantity",
    "roomMaximumPricePerUnit",
    "roomMeasurementUnit"
  ],
  computed: {
    showAction: function() {
      var codes = ["K", "P", "S", "W", "Y"];

      return this.condition.condition_code && codes.indexOf(this.condition.condition_code) === -1;
    },
    showConditionComponents: function() {
      var codes = ["01", "02", "03", "11", "12", "13", "15", "27", "34", "36"];

      return codes.indexOf(this.condition.action_code) > -1;
    },
    showMinimumPrice: function() {
      var codes = ["F", "G", "L", "N"];

      return codes.indexOf(this.condition.condition_code) > -1;
    },
    showMaximumQuantity: function() {
      var codes = ["E1", "I1"];

      return codes.indexOf(this.condition.condition_code) > -1;
    },
    showMaximumPricePerUnit: function() {
      var codes = ["E2", "I2"];

      return codes.indexOf(this.condition.condition_code) > -1;
    },
    showRatio: function() {
      var codes = ["R", "U"];

      return codes.indexOf(this.condition.condition_code) > -1;
    },
    showEntryPrice: function() {
      var codes = ["V"];

      return codes.indexOf(this.condition.condition_code) > -1;
    },
    showAmount: function() {
      var codes = ["E", "I", "M"];

      return codes.indexOf(this.condition.condition_code) > -1;
    },
    showCertificateType: function() {
      var codes = ["B", "C", "E3", "I3", "H", "Q", "Z", "V"];

      return codes.indexOf(this.condition.condition_code) > -1;
    },
    showCertificate: function() {
      var codes = ["A", "B", "C", "E3", "I3", "H", "Q", "Z", "V"];

      return codes.indexOf(this.condition.condition_code) > -1;
    },
    showAddMoreCertificates: function() {
      var codes = ["A", "Z"];

      return codes.indexOf(this.condition.condition_code) > -1;
    },
    canRemoveComponent: function() {
      return this.condition.measure_condition_components.length > 1;
    },
    showMonetaryUnit: function() {
      var codes = ["E2", "I2", "M1", "M2"];

      return codes.indexOf(this.condition.condition_code) > -1;
    },
    showMeasurementUnit: function() {
      var codes = ["E2", "I2", "M1", "M2"];

      return codes.indexOf(this.condition.condition_code) > -1;
    }
  },
  watch: {
    showAction: function() {
      if (!this.showAction) {
        this.condition.action_code = null;
        this.condition.measure_condition_components = [{
          duty_expression_id: null,
          amount: null,
          measurement_unit_code: null,
          measurement_unit_qualifier_code: null
        }];
      }
    },
    "condition.certificate_type_id": function() {
      this.certificate_id = null;
    },
    showCertificateType: function(newVal, oldVal) {
      if (oldVal === false && newVal === true) {
        this.certificate_id = null;
      }
    }
  },
  methods: {
    splitConditions: function(options) {
      return ConditionsParser.parse(options);
    },
    addMeasureConditionComponent: function() {
      this.condition.measure_condition_components.push({
        duty_expression_id: null,
        amount: null,
        measurement_unit_code: null,
        measurement_unit_qualifier_code: null
      });
    },
    removeMeasureConditionComponent: function(measureConditionComponent) {
      var idx = this.condition.measure_condition_components.indexOf(measureConditionComponent);

      if (idx === -1) {
        return;
      }

      this.condition.measure_condition_components.splice(idx, 1);
    },
    addCertificate: function() {

    },
    onConditionCodeSelected: function(obj) {
      this.condition.measure_condition_code = obj;
    },
    onCertificateTypeSelected: function(obj) {
      this.condition.certificate_type = obj;
    },
    onCertificateSelected: function(obj) {
      this.condition.certificate = obj;
    },
    onActionSelected: function(obj) {
      this.condition.measure_action = obj;
    },
    onMonetaryUnitSelected: function(obj) {
      this.condition.monetary_unit = obj;
    },
    onMeasurementUnitSelected: function(item) {
      this.condition.measurement_unit = item;
    },
    onMeasurementUnitQualifierSelected: function(item) {
      this.condition.measurement_unit_qualifier = item;
    }
  }
});
