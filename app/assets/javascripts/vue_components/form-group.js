var template = `
<div :class="{'form-group': true, 'form-group-error': hasError}"><slot v-bind:error="error" v-bind:hasError="hasError"></slot></div>
`;

Vue.component("form-group", {
  template: template,
  props: ["errors", "errorKey"],
  computed: {
    hasError: function() {
      return !!this.error;
    },
    error: function() {
      return this.errors ? this.errors[this.errorKey] : null;
    }
  }
});
