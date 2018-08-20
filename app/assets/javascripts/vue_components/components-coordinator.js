var template = [
  '<div>',
    '<div :class="classes" v-for="(component, idx) in components">',
      '<measure-condition-component v-if="isMeasureConditionComponent" :measure-condition-component="component" :index="Math.max(idx,index)" :room-duty-amount-or-percentage="showDutyAmountOrPercentage" :room-duty-amount-percentage="showDutyAmountPercentage" :room-duty-amount-negative-percentage="showDutyAmountNegativePercentage" :room-duty-amount-number="showDutyAmountNumber" :room-duty-amount-minimum="showDutyAmountMinimum" :room-duty-amount-maximum="showDutyAmountMaximum" :room-duty-amount-negative-number="showDutyAmountNegativeNumber" :room-duty-refund-amount="showDutyRefundAmount" :room-monetary-unit="showMonetaryUnit" :room-measurement-unit="showMeasurementUnit">',
        '<div class="col-md-1 align-bottom" v-if="canRemoveComponent">',
          '<div class="form-group">',
            '<label for="" class="form-label" v-if="index == 0 && idx == 0">&nbsp;</label>',
            '<a class="secondary-button text-danger" href="#" v-on:click.prevent="removeComponent(idx)">',
              'Remove',
            '</a>',
          '</div>',
        '</div>',
      '</measure-condition-component>',
      '<measure-component v-if="isMeasureComponent" :measure-component="component" :index="Math.max(idx,index)" :room-duty-amount-or-percentage="showDutyAmountOrPercentage" :room-duty-amount-percentage="showDutyAmountPercentage" :room-duty-amount-negative-percentage="showDutyAmountNegativePercentage" :room-duty-amount-number="showDutyAmountNumber" :room-duty-amount-minimum="showDutyAmountMinimum" :room-duty-amount-maximum="showDutyAmountMaximum" :room-duty-amount-negative-number="showDutyAmountNegativeNumber" :room-duty-refund-amount="showDutyRefundAmount" :room-monetary-unit="showMonetaryUnit" :room-measurement-unit="showMeasurementUnit">',
        '<div class="col-md-1 align-bottom" v-if="canRemoveComponent">',
          '<div class="form-group">',
            '<label for="" class="form-label" v-if="index == 0 && idx == 0">&nbsp;</label>',
            '<a class="secondary-button text-danger" href="#" v-on:click.prevent="removeComponent(idx)">',
              'Remove',
            '</a>',
          '</div>',
        '</div>',
      '</measure-component>',
    '</div>',
    '<p>',
      '<a href="#" v-on:click.prevent="addComponent" v-if="isMeasureConditionComponent">Add another component</a>',
      '<a href="#" v-on:click.prevent="addComponent" v-if="isMeasureComponent">Add another duty expression</a>',
    '</p>',
  '</div>'
].join("");

Vue.component("components-coordinator", {
  template: template,
  props: ["components", "type", "classes", "index"],
  data: function() {
    return {

    };
  },
  methods: {
    any: function(arr, func) {
      return arr.filter(function(element) {
        return func(element);
      }).length > 0;
    },
    removeCondition: function(index) {
      this.components.splice(index, 1);
    },
    addComponent: function() {
      this.components.push({
        duty_expression_id: null,
        amount: null,
        measurement_unit_code: null,
        measurement_unit_qualifier_code: null
      });
    }
  },
  computed: {
    canRemoveComponent: function() {
      return this.components.length > 1;
    },
    isMeasureConditionComponent: function() {
      return this.type == "measure_condition_component";
    },
    isMeasureComponent: function() {
      return this.type == "measure_component";
    },
    showDutyAmountOrPercentage: function() {
      var ids = ["01", "02", "04", "19", "20"];

      return this.any(this.components, function(component) {
        return ids.indexOf(component.duty_expression_id) > -1;
      });
    },
    showDutyAmountPercentage: function() {
      var ids = ["23", "01A", "04A", "19A", "20A"];

      return this.any(this.components, function(component) {
        return ids.indexOf(component.duty_expression_id) > -1;
      });
    },
    showDutyAmountNegativePercentage: function() {
      var ids = ["36", "02A"];

      return this.any(this.components, function(component) {
        return ids.indexOf(component.duty_expression_id) > -1;
      });
    },
    showDutyAmountNumber: function() {
      var ids = ["01B", "04B", "19B", "20B", "06", "07", "09", "11", "12", "13", "14", "21", "25", "27", "29", "31"];

      return this.any(this.components, function(component) {
        return ids.indexOf(component.duty_expression_id) > -1;
      });
    },
    showDutyAmountMinimum: function() {
      var ids = ["15"];

      return this.any(this.components, function(component) {
        return ids.indexOf(component.duty_expression_id) > -1;
      });
    },
    showDutyAmountMaximum: function() {
      var ids = ["17", "35"];

      return this.any(this.components, function(component) {
        return ids.indexOf(component.duty_expression_id) > -1;
      });
    },
    showDutyAmountNegativeNumber: function() {
      var ids = ["02B"];

      return this.any(this.components, function(component) {
        return ids.indexOf(component.duty_expression_id) > -1;
      });
    },
    showDutyRefundAmount: function() {
      var ids = ["40", "41", "42", "43", "44"];

      return this.any(this.components, function(component) {
        return ids.indexOf(component.duty_expression_id) > -1;
      });
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

      return this.any(this.components, function(component) {
        return component.duty_expression_id && ids.indexOf(component.duty_expression_id) === -1;
      });
    }
  }
});
