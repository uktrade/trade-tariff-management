var template = [
  '<div>',
    '<div :class="classes" v-for="(component, idx) in components">',
      '<measure-condition-component v-if="isMeasureConditionComponent" :measure-condition-component="component" :index="Math.max(idx,index)" :room-monetary-unit="showMonetaryUnit">',
        '<div class="col-md-1 align-bottom" v-if="canRemoveComponent">',
          '<div class="form-group">',
            '<label for="" class="form-label" v-if="index == 0 && idx == 0">&nbsp;</label>',
            '<a class="secondary-button text-danger" href="#" v-on:click.prevent="removeComponent(idx)">',
              'Remove',
            '</a>',
          '</div>',
        '</div>',
      '</measure-condition-component>',
      '<measure-component v-if="isMeasureComponent" :measure-component="component" :index="Math.max(idx,index)" :room-monetary-unit="showMonetaryUnit">',
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
    showMonetaryUnit: function() {
      return false;
    }
  }
});
