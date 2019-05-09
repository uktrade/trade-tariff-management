var template = [
  '<div>',
    '<div :class="classes" v-for="(component, idx) in components">',
      '<measure-condition-component :id="\'measure-condition-\' + index + \'-measure-condition-component-\' + idx" v-if="isMeasureConditionComponent" :disabled="isDisabled" :measure-condition-component="component" :prefix="(prefix ? prefix + \'-\' : \'\') + \'measure-condition-\' + index + \'-measure-condition-component-\' + idx + \'-\'" :index="Math.max(idx,index)" :room-duty-amount="showDutyAmount" :room-measurement-unit="showMeasurementUnit" :room-monetary-unit="showMonetaryUnit">',
        '<div class="col-md-1 align-bottom" v-if="canRemoveComponent">',
          '<div class="form-group">',
            '<label for="" class="form-label" v-if="index == 0 && idx == 0">&nbsp;</label>',
            '<a class="secondary-button text-danger" href="#" v-on:click.prevent="removeComponent(idx)">',
              'Remove',
            '</a>',
          '</div>',
        '</div>',
      '</measure-condition-component>',
      '<measure-component :id="(prefix ? prefix + \'-\' : \'\') + \'measure-component-\' + idx" :prefix="(prefix ? prefix + \'-\' : \'\') + \'measure-component-\' + idx" v-if="isMeasureComponent" :disabled="isDisabled" :measure-component="component" :index="Math.max(idx,index)" :room-monetary-unit="showMonetaryUnit" :room-duty-amount="showDutyAmount" :room-measurement-unit="showMeasurementUnit">',
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
    '<a href="#" v-on:click.prevent="addComponent" v-if="isMeasureConditionComponent">Add another component</a>',
    '<a href="#" v-on:click.prevent="addComponent" v-if="isMeasureComponent">Add another duty expression</a>',
  '</div>'
].join("");

Vue.component("components-coordinator", {
  template: template,
  props: [
    "components",
    "conditions",
    "type",
    "classes",
    "index",
    "prefix",
    "showConditionsDutyAmount",
    "showConditionsMeasurementUnit"
  ],
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
    removeComponent: function(index) {
      this.components.splice(index, 1);
    },
    addComponent: function() {
      this.components.push({
        duty_expression_id: null,
        amount: null,
        measurement_unit_code: null,
        measurement_unit_qualifier_code: null
      });
    },
    flattenArray: function(arrays) {
      return [].concat.apply([], arrays)
    }
  },
  computed: {
    isDisabled: function() {
      if (this.conditions === undefined) {
        return;
      }
      var conditions_allow_duty = this.conditions.map(function(condition) {
        return condition.measure_condition_components.map(function (component) {
          return (component.duty_expression_id == undefined || component.duty_expression_id == "")
        })
      })
      return this.flatten_array(conditions_allow_duty).includes(false);
    },
    canRemoveComponent: function() {
      return this.components.length > 1;
    },
    isMeasureConditionComponent: function() {
      return this.type == "measure_condition_component";
    },
    isMeasureComponent: function() {
      return this.type == "measure_component";
    },
    showMonetaryUnit: function() {
      return false;
    },
    showDutyAmount: function() {
      var ids = ["12", "14", "21", "25", "27", "29", "37", "99"];

      if (this.showConditionsDutyAmount === true) {
        return true;
      }

      return this.any(this.components, function(component) {
        return component.duty_expression_id && ids.indexOf(component.duty_expression_id) === -1;
      });
    },
    showMeasurementUnit: function() {
      var ids = ["12", "14", "21", "23", "25", "27", "29", "36", "37", "01A", "02A", "04A", "15A", "17A", "19A", "20A", "35A"];

      if (this.showConditionsMeasurementUnit === true) {
        return true;
      }

      return this.any(this.components, function(component) {
        return component.duty_expression_id && ids.indexOf(component.duty_expression_id) === -1;
      });
    },
  }
});
